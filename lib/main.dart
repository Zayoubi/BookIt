import 'package:final_project/auth.dart';
import 'package:final_project/court_screens/court_edit.dart';
import 'package:final_project/court_screens/court_repair.dart';
import 'package:final_project/court_screens/court_report.dart';
import 'package:final_project/court_screens/reservation_provider.dart';
import 'package:final_project/signup_page.dart';
import 'package:final_project/splash_screen.dart';
import 'package:final_project/users_screens/court_owner.dart';
import 'package:final_project/users_screens/player_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';  // Correct import for date formatting
import 'package:provider/provider.dart';  // Import Provider if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize date formatting for the desired locale (e.g., 'en' for English)
  await initializeDateFormatting('en', ''); //

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
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
      debugShowCheckedModeBanner: false,
      home: const CourtOwner(),  // Set UserPage as the home

      routes: {
        '/authpage': (context) => const AuthPage(),
        '/userpage': (context) => const UserPage(),
        '/courtownerpage': (context) => const CourtOwner(),
        '/courtedit': (context) => const CourtEdit(),
        '/courtrepair': (context) => const CourtRepair(),
        '/courtreport': (context) => const CourtReport(),
      },
    );
  }
}
