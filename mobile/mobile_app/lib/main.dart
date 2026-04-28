import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/local_storage_service.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/emergency_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/responder_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/settings_provider.dart';

// Theme
import 'theme/app_theme.dart';

// Screens
import 'features/splash/screens/splash_screen.dart';
import 'features/splash/screens/about_screen.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/dashboard/screens/dashboard_home_screen.dart';
import 'features/emergency/screens/alert_status_screen.dart';
import 'features/emergency/screens/emergency_trigger_screen.dart';
import 'features/responder/screens/nearby_alerts_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';
import 'features/settings/screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization warning: $e');
  }
  
  // Initialize local storage
  await LocalStorageService.initialize();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('✅ Environment variables loaded from .env');
  } catch (e) {
    debugPrint('⚠️ Warning: Could not load .env file. Please ensure it exists for API integrations.');
  }
  
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://example@sentry.io/add-your-dsn-here'; // Replace with actual DSN in production
      options.tracesSampleRate = 1.0; // Capture 100% of transactions for performance monitoring
    },
    appRunner: () => runApp(const RapidResponseApp()),
  );
}

class RapidResponseApp extends StatelessWidget {
  const RapidResponseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ResponderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Rapid Response System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/about': (context) => const AboutScreen(),
          '/auth': (context) => const AuthScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/dashboard': (context) => const DashboardHomeScreen(),
          '/alert-status': (context) => const AlertStatusScreen(),
          '/emergency-trigger': (context) => const EmergencyTriggerScreen(),
          '/nearby-alerts': (context) => const NearbyAlertsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
