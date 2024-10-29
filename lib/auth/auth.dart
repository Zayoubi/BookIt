import 'package:final_project/auth/reset_password.dart';
import 'package:final_project/signup_page.dart';
import 'package:final_project/users_screens/court_owner.dart';
import 'package:final_project/users_screens/player_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool _obscureText = true; // To track password visibility

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const CourtOwner()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(11, 102, 35, 1)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/login.json', height: 200),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Sign in ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(color: Colors.yellow, fontSize: 24),
                ),
              ),
              _buildTextField(context, 'Email', _emailController, Icons.email, false),
              const SizedBox(height: 10),
              _buildTextField(context, 'Password', _passwordController, Icons.lock, true),
              _buildForgotPasswordButton(context),
              _buildLoginButton(context),
              const SizedBox(height: 10),
              _buildGoogleSignInButton(context),
              const SizedBox(height: 10),
              _buildRegisterText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String hintText, TextEditingController controller, IconData icon, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && _obscureText,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              border: InputBorder.none,
              hintText: hintText,
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage())),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Forgot your password?', style: GoogleFonts.roboto(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: _login,
        child: Center(
          child: Text(
            'Login',
            style: GoogleFonts.roboto(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () => signInWithGoogle(context),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login with Google', style: GoogleFonts.roboto(fontSize: 15, color: Colors.black)),
              const SizedBox(width: 5),
              Image.asset('assets/google.png', width: 17),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "Don't Have An Account?", style: GoogleFonts.roboto(color: Colors.white)),
          TextSpan(
            text: " Register",
            style: GoogleFonts.roboto(color: Colors.yellow),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
              },
          ),
        ],
      ),
    );
  }

  void _login() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Check if the email is verified
      // if (!userCredential.user!.emailVerified) {
      //   // Sign out the user if the email is not verified
      //   await FirebaseAuth.instance.signOut();
      //
      //   // Show alert dialog
      //   _showEmailVerificationDialog();
      //   return; // Exit the method early
      // }

      final User? user = userCredential.user;
      if (user != null) {
        final String uid = user.uid;
        final DocumentSnapshot playerDoc = await _firestore.collection('user_player').doc(uid).get();
        final DocumentSnapshot courtOwnerDoc = await _firestore.collection('user_courtowner').doc(uid).get();
        final DocumentSnapshot adminDoc = await _firestore.collection('user_admin').doc(uid).get();

        if (playerDoc.exists) {
          Navigator.pushReplacementNamed(context, '/userpage');
        } else if (courtOwnerDoc.exists) {
          Navigator.pushReplacementNamed(context, '/courtownerpage');
        } else if (adminDoc.exists) {
          Navigator.pushReplacementNamed(context, '/adminpage');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User role not recognized.')),
          );
        }
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = 'Email or password incorrect';
        if (e.code == 'user-not-found') {
          errorMessage = 'User not found';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  // Function to show a simple alert dialog for email verification
  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Verification Required'),
          content: const Text('Please verify your email before logging in.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
