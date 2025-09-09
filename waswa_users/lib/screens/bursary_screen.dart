import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/bursary_application.dart';
import '../models/mock_data.dart';
import '../utils/theme.dart';
import '../di/service_locator.dart';
import '../services/bursary_application_service.dart';

class BursaryScreen extends StatefulWidget {
  const BursaryScreen({super.key});

  @override
  State<BursaryScreen> createState() => _BursaryScreenState();
}

class _BursaryScreenState extends State<BursaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _childNameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _parentIncomeController = TextEditingController();
  String _selectedSchool = '';
  bool _isLoading = false;
  bool _showApplications = false;
  List<BursaryApplication> _applications = [];
  late final BursaryApplicationService _bursaryApplicationService;
  bool _isLoadingApplications = false;

  @override
  void initState() {
    super.initState();
    _bursaryApplicationService = ServiceLocator().bursaryApplicationService;
    _loadApplications();
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _schoolController.dispose();
    _parentIncomeController.dispose();
    super.dispose();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoadingApplications = true;
    });
    
    try {
      final applications = await _bursaryApplicationService.getAllApplications();
      setState(() {
        _applications = applications;
        _isLoadingApplications = false;
      });
    } catch (e) {
      print('Error loading applications: $e');
      setState(() {
        _isLoadingApplications = false;
      });
      Fluttertoast.showToast(
        msg: 'Error loading applications',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppTheme.errorColor,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create new bursary application
      final application = BursaryApplication(
        childName: _childNameController.text.trim(),
        school: _selectedSchool,
        parentIncome: double.parse(_parentIncomeController.text.trim()),
        applicationDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'pending',
        userId: 1, // TODO: Get actual user ID from auth service
      );

      // Save to database
      final savedApplication = await _bursaryApplicationService.createApplication(application);
      
      if (savedApplication != null) {
        Fluttertoast.showToast(
          msg: 'Bursary application submitted successfully!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.successColor,
          textColor: Colors.white,
        );

        // Clear form
        _childNameController.clear();
        _schoolController.clear();
        _parentIncomeController.clear();
        setState(() {
          _selectedSchool = '';
          _isLoading = false;
          _showApplications = true;
        });

        // Reload applications
        await _loadApplications();
      } else {
        throw Exception('Failed to save application');
      }
    } catch (e) {
      print('Error submitting application: $e');
      Fluttertoast.showToast(
        msg: 'Error submitting application. Please try again.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppTheme.errorColor,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Bursary Application'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showApplications = !_showApplications;
              });
              if (_showApplications) {
                _loadApplications();
              }
            },
            child: Text(
              _showApplications ? 'New Application' : 'View Applications',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _showApplications
          ? _buildApplicationsList()
          : _buildApplicationForm(),
    );
  }

  Widget _buildApplicationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.successColor,
                    AppTheme.successColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.school, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Educational Support',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Apply for bursary support for your child\'s education',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Form Fields
            TextFormField(
              controller: _childNameController,
              decoration: const InputDecoration(
                labelText: 'Child\'s Full Name',
                prefixIcon: Icon(Icons.person_outline),
                helperText: 'Enter the student\'s full name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter child\'s name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSchool.isEmpty ? null : _selectedSchool,
              decoration: const InputDecoration(
                labelText: 'School',
                prefixIcon: Icon(Icons.school_outlined),
                helperText: 'Select the school your child attends',
              ),
              items: MockData.regionSchools.map((school) {
                return DropdownMenuItem(value: school, child: Text(school));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSchool = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a school';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _parentIncomeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Parent/Guardian Monthly Income (KES)',
                prefixIcon: Icon(Icons.attach_money_outlined),
                helperText: 'Enter your monthly income in Kenyan Shillings',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter monthly income';
                }
                final income = double.tryParse(value);
                if (income == null) {
                  return 'Please enter a valid number';
                }
                if (income <= 0) {
                  return 'Income must be greater than 0';
                }
                if (income > 1000000) {
                  return 'Income seems too high. Please verify.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitApplication,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Submit Application'),
              ),
            ),
            const SizedBox(height: 16),
            // Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Application Guidelines',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Applications are reviewed within 2-3 weeks\n'
                    '• Priority given to families with lower income\n'
                    '• Students must be enrolled in Region schools\n'
                    '• Supporting documents may be required',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList() {
    if (_isLoadingApplications) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_applications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No applications yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Submit your first bursary application above',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadApplications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _applications.length,
      itemBuilder: (context, index) {
        final application = _applications[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getStatusColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.school,
                  color: _getStatusColor(application.status),
                  size: 24,
                ),
              ),
            title: Text(
              application.childName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(application.school),
                Text('Income: KES ${application.parentIncome.toStringAsFixed(0)}'),
                Text('Applied: ${_formatDate(application.applicationDate)}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(application.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                application.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.warningColor;
      case 'rejected':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }
}
