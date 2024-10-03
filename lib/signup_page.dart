import 'package:final_project/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

enum Role { courtOwner, player }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formSignup = GlobalKey<FormState>();
  final _courtNameController = TextEditingController();
  final _courtEmailController = TextEditingController();
  final _playerNameController = TextEditingController();
  final _playerEmailController = TextEditingController();
  final _passController = TextEditingController();
  Role _selectedRole = Role.courtOwner;

  final userPlayer = FirebaseFirestore.instance.collection('user_player');
  final userCourtOwner = FirebaseFirestore.instance.collection('user_courtowner');

  Future<void> addPlayer() async {
    if (formSignup.currentState!.validate()) {
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _playerEmailController.text,
          password: _passController.text,
        );
        await userPlayer.doc(userCredential.user!.uid).set({
          'Name': _playerNameController.text.trim(),
          'Email': _playerEmailController.text.trim(),
          'UID': userCredential.user!.uid,
          'Role': 'player', // Set the role to 'player'
        });
        if (mounted) {
          _showSnackBar('Court Owner added successfully');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AuthPage())
          );
        }
      } catch (e) {
        if (e is FirebaseException) {
          if (e.code == 'email-already-in-use') {
            _showSnackBar('Email already in use');
          } else if (e.code == 'weak-password') {
            _showSnackBar('Password is too weak');
          } else {
            _showSnackBar('Failed to add Player');
          }
        }
      }
    }
  }

  Future<void> addCourtOwner() async {
    if (formSignup.currentState!.validate()) {
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _courtEmailController.text,
          password: _passController.text,
        );
        await userCourtOwner.doc(userCredential.user!.uid).set({
          'Name': _courtNameController.text.trim(),
          'CourtEmail': _courtEmailController.text.trim(),
          'UID': userCredential.user!.uid,
          'Role': 'courtOwner', // Set the role to 'courtOwner'
        });
        if (mounted) {
          _showSnackBar('Court Owner added successfully');
          Navigator.of(context).pushReplacementNamed('login');
        }
      } catch (e) {
        if (e is FirebaseException) {
          if (e.code == 'email-already-in-use') {
            _showSnackBar('Email already in use');
          } else if (e.code == 'weak-password') {
            _showSnackBar('Password is too weak');
          } else {
            _showSnackBar('Failed to add Court Owner');
          }
        }
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _courtNameController.dispose();
    _courtEmailController.dispose();
    _playerNameController.dispose();
    _playerEmailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formSignup,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(11, 102, 35, 1),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // animation
                  Row(
                    children: [
                       IconButton(
                          onPressed: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (_)=>const AuthPage()
                            )
                            );
                          },
                          icon: const Icon(Icons.arrow_back_sharp,color: Colors.white,)
                      ),

                      Lottie.asset('assets/login.json', height: 200),
                    ],
                  ),

                  // title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Create Account ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.yellow,
                        fontSize: 24,
                      ),
                    ),
                  ),

                  // role dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<Role>(
                      value: _selectedRole,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                        });
                      },
                      items: Role.values.map((role) => DropdownMenuItem<Role>(
                        value: role,
                        child: Text(role.toString().split('.').last),
                      ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (_selectedRole == Role.courtOwner)
                    ...[
                      // court name input
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
                              controller: _courtNameController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: InputBorder.none,
                                hintText: 'Court name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),



                      // court email input
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
                              textAlignVertical: TextAlignVertical.center,
                              controller: _courtEmailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: InputBorder.none,
                                hintText: 'Email',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // court password input
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
                              textAlignVertical: TextAlignVertical.center,
                              controller: _passController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: addCourtOwner,
                          child: const Text('Sign Up as Court Owner'),
                        ),
                      ),
                    ]
                  else
                    ...[
                      // player name input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white ,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _playerNameController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: InputBorder.none,
                                hintText: 'Player Name',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // player email input
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
                              textAlignVertical: TextAlignVertical.center,
                              controller: _playerEmailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: InputBorder.none,
                                hintText: 'Player Email',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              textAlignVertical: TextAlignVertical.center,
                              controller: _passController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                            ),
                          ),
                        ),
                      ),


                        // padding: const EdgeInsets.all(10.0),
                         ElevatedButton(
                          onPressed: addPlayer,
                          child: const Text('Sign Up as Player'),

                      ),
                    ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}