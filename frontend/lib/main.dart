import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'user_provider.dart';
import 'bluetooth_provider.dart';
import 'location_provider.dart';
import 'auth_service.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        Provider(create: (_) => AuthService()),
      ],
      child: const AxioVitalApp(),
    ),
  );
}

class AxioVitalApp extends StatelessWidget {
  const AxioVitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AxioVital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      home: const MobileWrapper(child: HomePage()),
    );
  }
}

class MobileWrapper extends StatelessWidget {
  final Widget child;
  const MobileWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Force a mobile-like aspect ratio if running on web/desktop
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        child: child,
      ),
    );
  }
}
