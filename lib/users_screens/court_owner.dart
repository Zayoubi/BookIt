import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/auth.dart';
import 'package:final_project/court_screens/court_owner_home.dart';
import 'package:final_project/court_screens/court_reservation_screen.dart';
import 'package:final_project/court_screens/court_edit.dart';
import 'package:final_project/court_screens/court_owner_profile.dart';
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
  String courtOwnerName = 'Loading...'; // Default name

  // Define your pages
  final List<Widget> pages = [
    const CourtHomeScreen(),
    CourtOwnerBookingList(),
    const CourtEdit(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchCourtOwnerName(); // Fetch court owner's name on initialization
  }

  Future<void> _fetchCourtOwnerName() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the court owner's name from Firestore
        DocumentSnapshot ownerDoc = await FirebaseFirestore.instance.collection('user_courtowner').doc(user.uid).get();

        if (ownerDoc.exists) {
          setState(() {
            courtOwnerName = ownerDoc['Name'] ?? 'No Name'; // Update with fetched name
          });
        } else {
          setState(() {
            courtOwnerName = 'Court Owner'; // Default if no data found
          });
        }
      }
    } catch (e) {
      print('Error fetching court owner name: $e');
      setState(() {
        courtOwnerName = 'Error loading name'; // In case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          index == 0 ? 'Home' : index == 1 ? 'Reservation' : 'Court',
          style: const TextStyle(color: Colors.green),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const CourtOwnerProfile()),
              );
            },
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/564x/fa/ba/9c/faba9cee9216338e69709d685e08d390.jpg',
                    ),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    courtOwnerName, // Use the fetched name here
                    style: const TextStyle(
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_)=>const CourtOwnerProfile()
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                );
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
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            selectedIcon: Icon(Icons.calendar_month_outlined),
            label: 'Reservation',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_soccer_outlined),
            selectedIcon: Icon(Icons.sports_soccer),
            label: 'Court',
          ),
        ],
      ),
      body: pages[index], // Use the selected page here
    );
  }
}
