import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';

enum Role { courtOwner, player }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState>formSignup =GlobalKey();
  final _courtNameController = TextEditingController();
  final _courtAddressController = TextEditingController();
  final _playerNameController = TextEditingController();
  final _playerEmailController = TextEditingController();
  final _passController = TextEditingController();
  Role _selectedRole = Role.courtOwner;

  CollectionReference userPlayer = FirebaseFirestore.instance.collection('user');
  CollectionReference userCourtOwner = FirebaseFirestore.instance.collection('user_courtowner');

  // Add data about player
  Future<void> addPlayer() async {
    if(formSignup.currentState!.validate()){
      try {
        DocumentReference response = await userPlayer.add({
          'Name': _playerNameController.text.trim(), // John Doe
          'Email': _playerEmailController.text.trim(), // Stokes and Sons
          'Password': _passController.text.trim()
        });
        if(mounted) { // 42
          _showSnackBar('Player added successfully');
          Navigator.of(context).pushReplacementNamed('login');
        }
      }catch(e) {
        _showSnackBar('Failed to add Player');
      }
      }
      }

  Future<void> addCourtOwner() async {
    if(formSignup.currentState!.validate()) {
      try {
        await userCourtOwner.add({
          'CourtName': _courtNameController.text.trim(),
          'CourtAddress': _courtAddressController.text.trim(),
        });
        if(mounted) {
          _showSnackBar('Court Owner added successfully');
          Navigator.of(context).pushReplacementNamed('login');
        }
      } catch (e) {
        if(mounted) {
          _showSnackBar('Failed to add Court Owner');
        }
      }
    }
  }

  void _showSnackBar(String message ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: const TextStyle(
          color:Colors.white,
        ),
        ),
        backgroundColor: Colors.black, // Set background color to black
         // Set font color to white
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _courtNameController.dispose();
    _courtAddressController.dispose();
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
                  Lottie.asset('assets/login.json', height: 200),

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

                  if (_selectedRole == Role.courtOwner) ...[
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
                              prefixIcon: Icon(Icons.place),
                              border: InputBorder.none,
                              hintText: 'Court Name',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // court address input
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
                            controller: _courtAddressController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.map),
                              border: InputBorder.none,
                              hintText: 'Court Address',
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
                  ] else ...[
                    // player name input
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
                            controller: _playerNameController,
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: addPlayer,
                        child: const Text('Sign Up as Player'),
                      ),
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