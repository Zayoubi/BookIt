import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'redirect_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration:  const BoxDecoration(

          color: Color.fromRGBO(11, 102, 35, 1),

        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100,left: 30), // Adjust top margin as needed
          child: SizedBox(
            width: double.infinity, // Make the column fill the full width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                //animation
              child:Lottie.asset('assets/home.json')
                ),
               const SizedBox(width: 20),
            const SizedBox(height: 50,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('BOOK ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                Text(" YOUR COURT",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                ],
                ),
                const SizedBox(height: 20,),
                     Text('With just a few taps,No more hassle,'
                        ' Book your court instantly',
                      style:  GoogleFonts.aBeeZee(
                        color: Colors.greenAccent,
                        fontSize: 15,
                      ),
                        ),
                const SizedBox(height: 20,),
                    //button
                    Center(
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RidirectScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size(double.infinity, 100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                          ),
                        ),


                        child: Padding(
                          padding: const EdgeInsets.only(left: 40,right: 40),
                          child: Text('GET STARTED',
                              style: GoogleFonts.roboto(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),

                            ),
                        ),
                        ),
                      )
                ,
              ],
            ),
          )
          )
            ),
          );
  }
}



