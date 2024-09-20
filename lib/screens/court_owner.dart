import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';



class CourtOwner extends StatefulWidget {
  const CourtOwner({super.key});

  @override
  State<CourtOwner> createState() => _CourtOwnerState();
}

class _CourtOwnerState extends State<CourtOwner> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: const Text(
        'BookIt',
        style: TextStyle(color: Colors.green),
    ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle_rounded,)),
          ],
    ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child:  Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://i.pinimg.com/564x/fa/ba/9c/faba9cee9216338e69709d685e08d390.jpg'),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Text('Ziad Ayoubi',style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),

                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Manage reservation'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:  const Icon(Icons.sports_soccer),
              title: const Text('Court'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:  const Icon(Icons.bar_chart),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:  const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                GoogleSignIn googleSignin=GoogleSignIn();
                googleSignin.disconnect();
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.green,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon:Icon(Icons.home) ,
              label: 'Home'
          ),
          NavigationDestination(
              icon: Icon(Icons.calendar_today),
              selectedIcon:Icon(Icons.calendar_month_outlined) ,
              label: 'Reservation'
          ),
          NavigationDestination(
              icon: Icon(Icons.sports_soccer_outlined),
              selectedIcon:Icon(Icons.sports_soccer_outlined) ,
              label: 'Court'
          ),


        ],

      ),
      body:Card(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            children:  [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration:  BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(15)
            ),
            child:  Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.calendar_month_outlined,size: 40,color: Colors.white,),
                   const SizedBox(height: 10),
                   Text('Manage',style: GoogleFonts.roboto(
                     fontSize: 18
                   ),),
                  Text('Reservation',style: GoogleFonts.roboto(
                    fontSize: 18,
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
        padding: const EdgeInsets.all(8.0),
    child: Container(
    decoration:  BoxDecoration(
    color: Colors.greenAccent,
    borderRadius: BorderRadius.circular(15)
    ),
    child:  Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Icon(Icons.sports_soccer,size: 40,color: Colors.white,),
    const SizedBox(height: 10),
    Text('Court',style: GoogleFonts.roboto(
    fontSize: 18
    ),
    ),

            ],
            ),
      )


    )
        ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration:  BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bar_chart,size: 40,color: Colors.white,),
                            const SizedBox(height: 10),
                            Text('Reports',style: GoogleFonts.roboto(
                                fontSize: 18
                            ),
                            ),

                          ],
                        ),
                      )
                  )
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration:  BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.build,size: 40,color: Colors.white,),
                            const SizedBox(height: 10),
                            Text('Maintenance',style: GoogleFonts.roboto(
                                fontSize: 18
                            ),
                            ),
                            Text('Request',style: GoogleFonts.roboto(
                                fontSize: 18
                            ),
                            ),

                          ],
                        ),
                      )
                  )
              ),
        ]
    ),
    )
    );
  }
}
