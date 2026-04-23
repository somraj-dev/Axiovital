import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/supabase_service.dart';
import 'checkout_provider.dart';
import 'orders_provider.dart';
import 'login_page.dart';
import 'splash_screen.dart';
import 'home_page.dart';
import 'user_provider.dart';
import 'bluetooth_provider.dart';
import 'location_provider.dart';
import 'cart_provider.dart';
import 'theme.dart';
import 'theme_provider.dart';
import 'community_provider.dart';
import 'call_provider.dart';

import 'notification_provider.dart';
import 'trackcoins_provider.dart';
import 'insurance_provider.dart';
import 'product_provider.dart';
import 'search_provider.dart';
import 'doctor_provider.dart';
import 'lab_provider.dart';
import 'consent_provider.dart';
import 'club_provider.dart';
import 'appointment_provider.dart';
import 'lab_booking_provider.dart';

// Set to true to bypass login and use a mock developer profile on localhost
const bool kIsAuthBypass = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase Cloud
  await SupabaseService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => CallProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => TrackcoinsProvider()),
        ChangeNotifierProvider(create: (_) => InsuranceProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => LabProvider()),
        ChangeNotifierProvider(create: (_) => ConsentProvider()),
        ChangeNotifierProvider(create: (_) => ClubProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => LabBookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'AxioVital',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.getTheme(false, themeProvider.primaryColor, preset: themeProvider.presetName),
      darkTheme: AppTheme.getTheme(true, themeProvider.primaryColor, preset: themeProvider.presetName),
      builder: (context, child) => MobileWrapper(child: child!),
      home: const SplashScreen(),
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
