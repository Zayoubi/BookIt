import 'package:final_project/widgets/court_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/button_header.dart';
import 'package:google_sign_in/google_sign_in.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final user=FirebaseAuth.instance.currentUser;
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
              leading: const Icon(Icons.phone),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:  const Icon(Icons.favorite),
              title: const Text('Favorite'),
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

      // bottomNavigationBar:
      //
      // Container(
      //   color: Colors.green[900],
      //   child: const Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      //     child: GNav(
      //
      //       color: Colors.black,
      //       activeColor: Colors.white,
      //       tabBackgroundColor: Colors.green,
      //       padding: EdgeInsets.all(16),
      //       gap: 8,
      //       tabs: [
      //         GButton(icon: Icons.home,text: 'Home',),
      //         GButton(icon: Icons.favorite_border,text: 'Favorite',),
      //         GButton(icon: Icons.person,text: 'Profile',),
      //       ],
      //     ),
      //   ),
      // ),


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

                   ButtonHeader(label: 'popular',),
               ButtonHeader(label: 'recommended'),
                ButtonHeader(label: 'location'),
              ],
            ),
          ),
          const SingleChildScrollView(
            child: Column(
              children: [
                CourtItem(
                    'Terre saint',
                    'Tripoli, Mina',
                    '\$10',
                   'https://plus.unsplash.com/premium_photo-1684713510655-e6e31536168d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                ),



              ],
                //first card
                        // Add other widgets here
            ),
          ),
              ],
            )
            );
  }
}



