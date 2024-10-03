import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/auth.dart';
import 'package:final_project/court_screens/court_owner_data.dart';
import 'package:final_project/court_screens/court_owner_data.dart';
import 'package:final_project/models/button_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int index = 0;

  // Define your pages
  final List<Widget> pages = [
    const  UserPage(),
    // const UserReservation(),
    // const (),
  ];
  final user = FirebaseAuth.instance.currentUser;

  Future<List<CourtOwnerData>> fetchCourtOwnerData() async {
    // Retrieve the list of CourtOwnerData objects from Firebase Firestore
    final firestore = FirebaseFirestore.instance;
    final courtOwnerCollection = firestore.collection('court_owners');
    final querySnapshot = await courtOwnerCollection.get();

    // Convert the query snapshot to a list of CourtOwnerData objects
    List<CourtOwnerData> courtOwnerDataList = querySnapshot.docs.map((doc) {
      return CourtOwnerData.fromMap(doc.data());
    }).toList();

    return courtOwnerDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'BookIt',
          style: TextStyle(color: Colors.green),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
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
                    backgroundImage: NetworkImage('https://i.pinimg.com/564x/fa/ba/9c/faba9cee9216338e69709d685e08d390.jpg'),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Text('Ziad Ayoubi',
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
              leading: const Icon(Icons.phone),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorite'),
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
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_today),
              selectedIcon: Icon(Icons.calendar_month_outlined),
              label: 'Reservation'),
          NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorite'),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 0.8),
                ),
                hintText: 'Search for a court',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ButtonHeader(label: 'popular'),
                ButtonHeader(label: 'recommended'),
                ButtonHeader(label: 'location'),
              ],
            ),
          ),
          FutureBuilder(
            future: fetchCourtOwnerData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CourtOwnerData> courtOwnerDataList = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: courtOwnerDataList.length,
                    itemBuilder: (context, index) {
                      CourtOwnerData courtOwnerData = courtOwnerDataList[index];
                      return CourtsCard(courtOwnerData: courtOwnerData);
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}

class CourtsCard extends StatelessWidget {
  final CourtOwnerData courtOwnerData;

  const CourtsCard({super.key, required this.courtOwnerData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(courtOwnerData.courtName),
            Text(courtOwnerData.courtAddress)
          ],
        ),
      ),
    );
  }
}