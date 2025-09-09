import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../di/service_locator.dart';
import '../models/user.dart';
import '../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _validateRegion(String idNumber) {
    // Basic validation: ID number should not be empty and have reasonable length
    return idNumber.trim().isNotEmpty && idNumber.trim().length >= 3;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final emailOrPhone = _emailController.text.trim();
      final password = _passwordController.text;
      
      // Determine if input is email or phone
      final isEmail = emailOrPhone.contains('@');
      final isPhone = RegExp(r'^[0-9+\-\s\(\)]{10,}$').hasMatch(emailOrPhone);
      
      if (!isEmail && !isPhone) {
        Fluttertoast.showToast(
          msg: 'Please enter a valid email or phone number',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
        return;
      }

      // Use authentication service
      final authService = ServiceLocator().authService;
      final user = await authService.login(emailOrPhone, password);

      if (user != null) {
        Fluttertoast.showToast(
          msg: 'Welcome back, ${user.name}!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.successColor,
          textColor: Colors.white,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Invalid email or password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Login failed: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppTheme.errorColor,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final name = _nameController.text.trim();
      final idNumber = _idNumberController.text.trim();
      final phone = _phoneController.text.trim();

      // Basic validation
      if (name.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Please enter your full name',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
        return;
      }

      if (!_validateRegion(idNumber)) {
        Fluttertoast.showToast(
          msg: 'Registration restricted to Region residents only',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
        return;
      }
      
      if (phone.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Please enter your phone number',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
        return;
      }

      // Check if user already exists
      final authService = ServiceLocator().authService;
      final existingUserByEmail = await authService.getUserByEmail(email);
      final existingUserByPhone = await authService.getUserByPhone(phone);
      
      if (existingUserByEmail != null) {
        Fluttertoast.showToast(
          msg: 'User already exists with this email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
        return;
      }
      
      if (existingUserByPhone != null) {
        Fluttertoast.showToast(
          msg: 'User already exists with this phone number',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
        return;
      }

      // Create new user
      final newUser = User(
        id: 0, // Temporary ID, will be replaced by database auto-increment
        name: name,
        email: email,
        phoneNumber: phone,
        password: password,
        role: 'USER',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 1,
        nationalId: idNumber,
        city: 'Webuye',
        state: 'Western',
        country: 'Kenya',
      );

      final createdUser = await authService.register(newUser);
      
      if (createdUser != null) {
        Fluttertoast.showToast(
          msg: 'Registration successful! Please login.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.successColor,
          textColor: Colors.white,
        );

        setState(() {
          _isSignUp = false;
          _emailController.clear();
          _passwordController.clear();
          _idNumberController.clear();
          _phoneController.clear();
          _nameController.clear();
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Registration failed. Please try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppTheme.errorColor,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Registration failed: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppTheme.errorColor,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Logo and Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            'assets/images/rn.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'JLW Foundation',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isSignUp ? 'Create Account' : 'Welcome Back',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Form Fields
                TextFormField(
                  controller: _emailController,
                  keyboardType: _isSignUp ? TextInputType.emailAddress : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: _isSignUp ? 'Email Address' : 'Email or Phone Number',
                    prefixIcon: Icon(_isSignUp ? Icons.email_outlined : Icons.person_outlined),
                    helperText: _isSignUp ? null : 'Enter your email address or phone number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone number';
                    }
                    if (_isSignUp) {
                      // For signup, validate as email
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                    } else {
                      // For login, accept email or phone number
                      final isEmail = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value);
                      final isPhone = RegExp(r'^[0-9+\-\s\(\)]{10,}$').hasMatch(value);
                      
                      if (!isEmail && !isPhone) {
                        return 'Please enter a valid email or phone number';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 3) {
                      return 'Password must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                // Name field (only for signup)
                if (_isSignUp) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                ],
                // Phone number field (only for signup)
                if (_isSignUp) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ],
                // ID Number field (only for signup)
                if (_isSignUp) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _idNumberController,
                    decoration: const InputDecoration(
                      labelText: 'ID Number',
                      prefixIcon: Icon(Icons.badge_outlined),
                      helperText: 'Enter your national ID or passport number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID number';
                      }
                      if (!_validateRegion(value)) {
                        return 'ID number must be at least 3 characters long';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                // Login/Signup Button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : (_isSignUp ? _handleSignUp : _handleLogin),
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
                      : Text(_isSignUp ? 'Sign Up' : 'Login'),
                ),
                const SizedBox(height: 16),
                // Toggle between Login and Signup
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                      _emailController.clear();
                      _passwordController.clear();
                      _idNumberController.clear();
                    });
                  },
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Login'
                        : 'Don\'t have an account? Sign Up',
                  ),
                ),
                const SizedBox(height: 24),
                // Demo credentials
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: AppTheme.surfaceColor,
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(
                //       color: AppTheme.primaryColor.withOpacity(0.2),
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Demo Credentials:',
                //         style:
                //             Theme.of(context).textTheme.titleMedium?.copyWith(
                //                   color: AppTheme.primaryColor,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //       ),
                //       const SizedBox(height: 8),
                //       Text(
                //         'Login with:\nEmail: user1@example.com\nPhone: 0706166875\nPassword: 123',
                //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
                //               color: AppTheme.textSecondaryColor,
                //             ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
