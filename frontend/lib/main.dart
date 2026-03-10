import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'user_provider.dart';
import 'bluetooth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AxioVital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      builder: (context, child) => MobileWrapper(child: child!),
      home: const LoginPage(),
    );
  }
}

class MobileWrapper extends StatelessWidget {
  final Widget child;
  const MobileWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Force mobile view if window is wide or high (like desktop)
        bool isWide = constraints.maxWidth > 500;
        bool isHigh = constraints.maxHeight > 950;

        if (isWide || isHigh) {
          // Define phone dimensions
          const double phoneWidth = 400;
          const double phoneHeight = 850;

          return Scaffold(
            backgroundColor: const Color(0xFF0F1113), // Deep dark background
            body: Center(
              child: Container(
                width: phoneWidth,
                height: phoneHeight,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(color: Colors.black, width: 12), // Bezels
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: MediaQuery(
                  // We OVERRIDE the media query so the app inside thinks it's strictly on a phone
                  data: MediaQuery.of(context).copyWith(
                    size: const Size(phoneWidth, phoneHeight),
                    padding: const EdgeInsets.only(top: 44.0), // Simulate status bar notch
                  ),
                  child: child,
                ),
              ),
            ),
          );
        }
        
        // If it's already a small screen (true mobile), show normally
        return child;
      },
    );
  }
}
