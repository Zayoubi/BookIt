import 'package:final_project/auth/auth.dart';
import 'package:final_project/court_screens/court_edit.dart';
import 'package:final_project/court_screens/court_report.dart';
import 'package:final_project/court_screens/reservation_provider.dart';
import 'package:final_project/onBoarding/onboarding_page.dart';
import 'package:final_project/player_screens/player_check_reservation.dart';
import 'package:final_project/player_screens/user_reservation.dart';
import 'package:final_project/signup_page.dart';
import 'package:final_project/splash_screen.dart';
import 'package:final_project/users_screens/court_owner.dart';
import 'package:final_project/users_screens/player_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';


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
      home:  const UserPage(),

      routes: {
        '/authpage': (context) => const AuthPage(),
        '/userpage': (context) => const UserPage(),
        '/courtownerpage': (context) => const CourtOwner(),
        '/adminpage':(context)=>const AuthPage(),
        '/courtEdit': (context) => const CourtEdit(),
        '/courtreport': (context) => const ReservationReportPage(),
      },
    );
  }
}
