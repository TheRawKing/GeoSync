import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GeoSyncApp());
}

class GeoSyncApp extends StatelessWidget {
  const GeoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
