import 'package:booking_calendar/booking_calendar.dart';
import 'package:final_project/auth.dart';
import 'package:final_project/court_screens/booking_page.dart';
import 'package:final_project/court_screens/courts_data.dart';
import 'package:final_project/player_screens/player_check_reservation.dart';
import 'package:final_project/player_screens/user_profile.dart';
import 'package:final_project/player_screens/user_reservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPage extends StatefulWidget {
    const UserPage({super.key});

    @override
    _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
    int index = 0;
    String? playerName; // Variable to hold the player's name
    String? profileImageUrl;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Define your list of courts here
    final List<Courts> courts = [
        Courts(
            id: '1',
            name: 'Court 1',
            location: 'Location 1',
            imageUrl: 'assets/pitch.jpg',
            price: 50.0,
        ),
        Courts(
            id: '2',
            name: 'Court 2',
            location: 'Location 2',
            imageUrl: 'assets/pitch.jpg',
            price: 60.0,
        ),
    ];

    List<CourtsBooking> reservations = []; // Store bookings
    late final List<Widget> pages;

    @override
    void initState() {
        super.initState();
        _loadPlayerInfo(); // Load player info
        pages = [
            UserReservation(courts: courts),
            PlayerReservationCheck(reservations: reservations, playerId: '12345'),
            const ProfilePage(),
        ];
    }

    Future<void> _loadPlayerInfo() async {
        try {
            final User? user = _auth.currentUser;

            if (user != null) {
                DocumentSnapshot playerDoc = await _firestore.collection('user_player').doc(user.uid).get();

                if (playerDoc.exists) {
                    final playerData = playerDoc.data() as Map<String, dynamic>?;
                    setState(() {
                        playerName = playerData?['Name'] ?? 'Unknown'; // Fetching the player's name from Firestore
                        profileImageUrl = playerData?['profileImageUrl'] ?? 'https://example.com/default_profile_image.png'; // Default image
                    });
                }
            }
        } catch (e) {
            print('Error fetching player data: $e');
        }
    }

    void navigateToBookingPage(BuildContext context) async {
        final newReservation = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const BookingPage(),
            ),
        );

        // If a new reservation is returned, add it to the reservations list
        if (newReservation != null) {
            setState(() {
                reservations.add(newReservation);
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Center(child: Text('BookIt')),
            ),
            drawer: Drawer(
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                        DrawerHeader(
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                            ),
                            child: Column(
                                children: [
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(profileImageUrl!),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                        playerName ?? 'Player Name',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Reservations'),
                            onTap: () {
                                setState(() {
                                    index = 0;
                                });
                                Navigator.pop(context); // Close the drawer
                            },
                        ),
                        ListTile(
                            leading: const Icon(Icons.check_circle),
                            title: const Text('Check Reservations'),
                            onTap: () {
                                setState(() {
                                    index = 1;
                                });
                                Navigator.pop(context); // Close the drawer
                            },
                        ),
                        ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Profile'),
                            onTap: () {
                                setState(() {
                                    index = 2;
                                });
                                Navigator.pop(context); // Close the drawer
                            },
                        ),
                        const Divider(), // Divider between menu options
                        ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AuthPage()), // Replace with your Auth page
                                );
                            },
                        ),
                    ],
                ),
            ),
            body: pages[index], // Show the selected page
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: index,
                onTap: (newIndex) {
                    setState(() {
                        index = newIndex; // Update selected index
                    });
                },
                items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Reservations'),
                    BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Check Reservations'),
                    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                ],
            ),
        );
    }
}
