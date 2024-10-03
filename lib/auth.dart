import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //login
    return Scaffold(
      body: Container(
        decoration:   const BoxDecoration(
      color: Color.fromRGBO(11, 102, 35, 1),
    ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/login.json', height: 200),

              // title
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Sign in ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.yellow,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _emailController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _passwordController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: 'password',
                      ),
                    ),
                  ),
                ),
              ),
             const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      if (user != null) {
        final String uid = user.uid;
        final DocumentSnapshot playerDoc = await _firestore.collection('user_player').doc(uid).get();
        final DocumentSnapshot courtOwnerDoc = await _firestore.collection('user_courtowner').doc(uid).get();

        if (playerDoc.exists) {
          if(mounted) {
            Navigator.pushReplacementNamed(context, '/userpage');
          }
        } else if (courtOwnerDoc.exists) {
          if(mounted) {
            Navigator.pushReplacementNamed(context, '/courtownerpage');
          }
        } else {
          // Handle the case where the user is not found in either collection
          if (kDebugMode) {
            print('User not found in either collection');
          }
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          if (kDebugMode) {
            print('User not found');
          }
        } else if (e.code == 'wrong-password') {
          if (kDebugMode) {
            print('Wrong password');
          }
        }
      }
    }
  }
}