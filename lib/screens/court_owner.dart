import 'package:final_project/court_owner_screens/court_home_screen.dart';
import 'package:final_project/court_owner_screens/court_edit.dart';
import 'package:final_project/court_owner_screens/court_reservation.dart';
import 'package:final_project/onBoarding/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int index = 0;

  // Define your pages
  final List<Widget> pages = [
    const CourtHomeScreen(),
    const CourtReservation(),
    const CourtEdit(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.green),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.account_circle_rounded)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/564x/fa/ba/9c/faba9cee9216338e69709d685e08d390.jpg'),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Ziad Ayoubi',
                    style: TextStyle(
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
              leading: const Icon(Icons.sports_soccer),
              title: const Text('Court'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                GoogleSignIn googleSignin = GoogleSignIn();
                googleSignin.disconnect();
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (selectedIndex) => setState(() => index = selectedIndex),
        backgroundColor: Colors.green,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_today),
              selectedIcon: Icon(Icons.calendar_month_outlined),
              label: 'Reservation'),
          NavigationDestination(
              icon: Icon(Icons.sports_soccer_outlined),
              selectedIcon: Icon(Icons.sports_soccer),
              label: 'Court'),
        ],
      ),
      body:
      pages[index], // Use the selected page here
    );
  }
}
