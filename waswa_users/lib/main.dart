import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'di/service_locator.dart';
import 'services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  await ServiceLocator().initialize();

  // Set up connectivity monitoring for sync (after service locator is initialized)
  _setupConnectivityMonitoring();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const JLWFoundationApp());
}

void _setupConnectivityMonitoring() {
  final syncService = ServiceLocator().syncServiceSafe;
  
  if (syncService != null) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      syncService.handleConnectivityChange(result);
    });
    print('Connectivity monitoring setup successfully');
  } else {
    print('Failed to setup connectivity monitoring: syncService not available');
    // Continue without connectivity monitoring
  }
}

class JLWFoundationApp extends StatelessWidget {
  const JLWFoundationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JLW Foundation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
