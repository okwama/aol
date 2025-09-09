import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../di/service_locator.dart';
import '../utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    try {
      print('SplashScreen: Starting login status check...');
      
      // Wait for service locator to be ready with retry mechanism
      await _waitForServiceLocator();
      
      final authService = ServiceLocator().authService;
      final isLoggedIn = await authService.isAuthenticated();

      if (mounted) {
        if (isLoggedIn) {
          print('SplashScreen: User is logged in, navigating to home');
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('SplashScreen: User is not logged in, navigating to login');
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      print('SplashScreen: Error during initialization: $e');
      if (mounted) {
        // Navigate to login as fallback instead of showing error dialog
        print('SplashScreen: Falling back to login screen');
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<void> _waitForServiceLocator() async {
    int retryCount = 0;
    const maxRetries = 5;
    const retryDelay = Duration(milliseconds: 500);
    
    while (retryCount < maxRetries) {
      try {
        // Try to access a service to verify service locator is ready
        final _ = ServiceLocator().authService;
        print('SplashScreen: Service locator is ready');
        return;
      } catch (e) {
        retryCount++;
        print('SplashScreen: Service locator not ready, retry $retryCount/$maxRetries: $e');
        
        if (retryCount < maxRetries) {
          await Future.delayed(retryDelay);
        } else {
          throw Exception('Service locator failed to initialize after $maxRetries attempts');
        }
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Initialization Error'),
          content: Text('Failed to initialize app: $error\n\nPlease try restarting the app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and Title
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // JLW Foundation Logo
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              'assets/images/rn.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'JLW Foundation',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Serving Webuye Region',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppTheme.textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            // Loading indicator
            SizedBox(
              width: 200,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: AppTheme.surfaceColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    minHeight: 4,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
}
