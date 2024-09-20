import 'package:final_project/login.dart';
import 'package:final_project/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        // Check if user is authenticated
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user != null) {
            // User is signed in
            return const UserPage(); // Replace with your home page
          } else {
            // User is not signed in
            return const LoginPage(); // Replace with your login page
          }
        }

        // While the connection is still active, show a loading indicator
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
