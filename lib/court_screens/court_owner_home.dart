import 'package:final_project/court_screens/court_edit.dart';
import 'package:final_project/court_screens/court_report.dart';
import 'package:final_project/court_screens/court_reservation_screen.dart';
import 'package:final_project/court_screens/ratingPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourtHomeScreen extends StatefulWidget {
  const CourtHomeScreen({super.key});

  @override
  State<CourtHomeScreen> createState() => _CourtHomeScreenState();
}
class _CourtHomeScreenState extends State<CourtHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child:
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              InkWell(
           onTap: () {
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(
            builder: (_) => const CourtOwnerBookingList()
            )
            );
            },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[200],
                      ),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_outlined,size: 40),
                          Text('Manage',style: GoogleFonts.roboto(
                            fontSize: 18,
                          ),
                          ),
                          Text('Reservstion',style: GoogleFonts.roboto(
                            fontSize: 18,
                          ),)
                        ],
                      ),
                    )
                ),
              ),
              InkWell(
                 onTap: (){
                   Navigator.of(context).pushReplacement(
                       MaterialPageRoute(
                           builder: (_) => const CourtEdit()
                       )
                   );
                 },


                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[200],
                      ),
                      child:    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.sports_soccer,size: 40),
                          Text('Court',style: GoogleFonts.roboto(
                            fontSize: 18,
                          ),
                          ),

                        ],
                      ),
                    )
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => const RatingPage()
                      )
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[200],
                      ),
                      child:    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_border,size: 40),
                          Text('Rate court',style: GoogleFonts.roboto(
                            fontSize: 18,
                          ),
                          ),

                        ],
                      ),
                    )
                ),
              ),
              InkWell(
    onTap: () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => const ReservationReportPage()
          )
      );
    },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[200],
                      ),
                      child:    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bar_chart,size: 40),
                          Text('Report',style: GoogleFonts.roboto(
                            fontSize: 18,
                          ),
                          ),
                        ],
                      ),
                    )
                ),
              ),

            ],
          ),
        ),


      ),

    );
  }
}