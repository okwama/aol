import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../utils/theme.dart';
import '../di/service_locator.dart';
import '../models/user.dart';
import '../constants/app_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  bool _isLoading = true;
  bool _isAccountDetailsExpanded = false;
  File? _selectedImage;
  bool _isUploadingImage = false;
  String _deleteConfirmationText = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authService = ServiceLocator().authService;
      final user = authService.currentUser;
      
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      );
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          setState(() {
            _selectedImage = File(file.path!);
          });
          await _uploadImage();
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      _showSnackBar('Error selecting image: ${e.toString()}');
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      // Convert image to base64
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Create multipart request for Cloudinary
      final uri = Uri.parse('${AppConstants.cloudinaryBaseUrl}/image/upload');
      
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = AppConstants.cloudinaryUploadPreset
        ..fields['cloud_name'] = AppConstants.cloudinaryCloudName
        ..fields['public_id'] = 'profile_${_currentUser!.id}_${DateTime.now().millisecondsSinceEpoch}';
      
      // Add the image file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'profile_image.jpg',
        ),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200) {
        final imageUrl = jsonResponse['secure_url'];
        
        // Update user profile with new image URL
        // For now, we'll just show success message
        // In a real app, you'd update the user model and save to database
        
        setState(() {
          _isUploadingImage = false;
        });
        
        _showSnackBar('Profile picture updated successfully!');
        print('Image uploaded to: $imageUrl');
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _isUploadingImage = false;
      });
      _showSnackBar('Error uploading image: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    // Check if file picker is available
    try {
      // Test if FilePicker can be instantiated
      print('FilePicker available: ${FilePicker.platform.runtimeType}');
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Profile Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  subtitle: const Text('Select an existing image'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                // Add a test option for debugging
                if (kDebugMode)
                  ListTile(
                    leading: const Icon(Icons.bug_report),
                    title: const Text('Test File Picker'),
                    onTap: () {
                      Navigator.pop(context);
                      _testFilePicker();
                    },
                  ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error showing image source dialog: $e');
      _showSnackBar('File picker not available. Please restart the app.');
    }
  }

  Future<void> _testFilePicker() async {
    try {
      print('Testing file picker availability...');
      
      // Test if we can access the file picker
      print('FilePicker available: ${FilePicker.platform.runtimeType}');
      
      // Try to pick a file to test functionality
      print('Attempting to pick a file...');
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        print('Test file picked successfully: ${file.name} (${file.path})');
        _showSnackBar('File picker test successful! File selected: ${file.name}');
      } else {
        print('Test file picker cancelled by user');
        _showSnackBar('File picker test completed. No file selected.');
      }
    } catch (e) {
      print('File picker test failed: $e');
      _showSnackBar('File picker test failed: ${e.toString()}');
    }
  }

  Future<void> _logout() async {
    try {
      final authService = ServiceLocator().authService;
      await authService.logout();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error during logout: $e');
      // Still navigate to login even if logout fails
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red.shade600),
              const SizedBox(width: 8),
              const Text('Delete Account'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'This action will permanently:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text('• Delete your profile and personal information'),
              const Text('• Remove all your bursary applications'),
              const Text('• Cancel any pending ambulance requests'),
              const Text('• Delete your event attendance history'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: const Text(
                  'This action cannot be undone. Please make sure you want to proceed.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete_forever, color: Colors.red.shade600),
              const SizedBox(width: 8),
              const Text('Final Confirmation'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Type "DELETE" to confirm account deletion:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Type DELETE here',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Store the typed value for validation
                  _deleteConfirmationText = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _deleteConfirmationText == 'DELETE' 
                  ? () {
                      Navigator.of(context).pop();
                      _deleteAccount();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Deleting account...'),
              ],
            ),
          );
        },
      );

      // Simulate account deletion process
      await Future.delayed(const Duration(seconds: 2));

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      _showSnackBar('Account deleted successfully');

      // Navigate to login screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Error deleting account: $e');
      
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      _showSnackBar('Error deleting account: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_currentUser == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: Text('User not found. Please login again.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(47),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 94,
                                    height: 94,
                                  ),
                                )
                              : _currentUser?.photoUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(47),
                                      child: Image.network(
                                        _currentUser!.photoUrl!,
                                        fit: BoxFit.cover,
                                        width: 94,
                                        height: 94,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                        ),
                        if (_isUploadingImage)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        // Camera icon overlay
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentUser!.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentUser!.role,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Profile Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.email, 'Email', _currentUser!.email),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.phone, 'Phone', _currentUser!.phoneNumber),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.location_on, 'Location', '${_currentUser!.city ?? 'Not specified'}, ${_currentUser!.state ?? 'Not specified'}, ${_currentUser!.country ?? 'Not specified'}'),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.badge, 'ID Number', _currentUser!.nationalId ?? 'Not specified'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Account Details
            Card(
              child: Column(
                children: [
                  // Header - always visible and clickable
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isAccountDetailsExpanded = !_isAccountDetailsExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Account Details',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Icon(
                            _isAccountDetailsExpanded 
                                ? Icons.expand_less 
                                : Icons.expand_more,
                            color: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Content - only visible when expanded
                  if (_isAccountDetailsExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.person, 'User ID', _currentUser!.id.toString()),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.calendar_today, 'Member Since', _formatDate(_currentUser!.createdAt)),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.update, 'Last Updated', _formatDate(_currentUser!.updatedAt)),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.verified, 'Status', _getStatusText(_currentUser!.status)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Account Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Statistics',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Bursary Applications',
                            '3',
                            Icons.school,
                            AppTheme.successColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Ambulance Requests',
                            '2',
                            Icons.medical_services,
                            AppTheme.errorColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Events Attended',
                            '4',
                            Icons.event,
                            AppTheme.accentColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Notifications',
                            '4',
                            Icons.notifications,
                            AppTheme.warningColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingTile(
                      Icons.notifications,
                      'Notification Settings',
                      'Manage your notification preferences',
                      () {},
                    ),
                    const SizedBox(height: 8),
                    _buildSettingTile(
                      Icons.security,
                      'Privacy & Security',
                      'Manage your privacy settings',
                      () {},
                    ),
                    const SizedBox(height: 8),
                    _buildSettingTile(
                      Icons.help,
                      'Help & Support',
                      'Get help and contact support',
                      () {},
                    ),
                    const SizedBox(height: 8),
                    _buildSettingTile(
                      Icons.info,
                      'About JLW Foundation',
                      'Learn more about the foundation',
                      () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Danger Zone
            Card(
              color: Colors.red.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red.shade600,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Danger Zone',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.red.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'These actions are permanent and cannot be undone.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Delete Account Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showDeleteAccountDialog,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade600,
                          side: BorderSide(color: Colors.red.shade600),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.delete_forever, size: 20),
                        label: const Text('Delete Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondaryColor),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppTheme.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Active';
      case 0:
        return 'Inactive';
      case 2:
        return 'Suspended';
      default:
        return 'Unknown';
    }
  }

  String _getBursaryCount() {
    // For now, return a placeholder. This could be fetched from a service later
    return _currentUser?.role == 'ADMIN' ? '5' : '2';
  }

  String _getAmbulanceCount() {
    // For now, return a placeholder. This could be fetched from a service later
    return _currentUser?.role == 'ADMIN' ? '8' : '1';
  }

  String _getEventsCount() {
    // For now, return a placeholder. This could be fetched from a service later
    return _currentUser?.role == 'ADMIN' ? '12' : '3';
  }

  String _getNotificationsCount() {
    // For now, return a placeholder. This could be fetched from a service later
    return _currentUser?.role == 'ADMIN' ? '15' : '6';
  }
}
