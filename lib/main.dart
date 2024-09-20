import 'package:final_project/auth.dart';
import 'package:final_project/login.dart';
import 'package:final_project/screens/court_owner.dart';
import 'package:final_project/screens/user_page.dart';

import 'package:final_project/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CourtOwner(),

      routes: {
        // 'auth': (context)=>const Auth(),
        'login':(context)=>const LoginPage(),
        'homepage':(context)=>const UserPage(),
      },
    );
  }
}
