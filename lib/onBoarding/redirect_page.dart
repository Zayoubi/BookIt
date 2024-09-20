import 'package:final_project/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../signup_page.dart';
import '../login.dart';

class RidirectScreen extends StatelessWidget {
  const  RidirectScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(11, 102, 35, 1),
        ),

        child:  Center(

          child:  Column(

            children: [
              const SizedBox(height: 40),
              Text("Let's Get Started",
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                color: Colors.white,
                fontSize: 25,
                ),
              ),
              const SizedBox(height:70 ),
              Lottie.asset('assets/redirect.json'),

              //sign up button
   const SizedBox(height: 60),
    ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AuthPage(),
    )
    );
    },
    style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(7),
    ),
    ),
    child:  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Text('Sign in',textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
    color: Colors.black54,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    ),
    )
    )
    ),

              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const SignupPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child:  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text('Sign up',textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  )
              ),


                      // recognizer: TapGestureRecognizer()
                      //   ..onTap = () {
                      //     // Navigate to sign-in screen
                      //     Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) =>  const Auth()),
                      //     );
                      //   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //
         ],
          ),
        ),
      ),
    );
  }
}
