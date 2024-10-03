import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  String? playerName;
  String? playerEmail;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadPlayerInfo();
  }

  // Method to get player information from Firestore using UID
  Future<void> _loadPlayerInfo() async {
    try {
      final User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot playerDoc = await _firestore.collection('user_player').doc(user.uid).get();

        if (playerDoc.exists) {
          final playerData = playerDoc.data() as Map<String, dynamic>?;
          setState(() {
            playerName = playerData?['Name'] ?? 'Unknown';
            playerEmail = playerData?['Email'] ?? 'No Email';
            profileImageUrl = playerData?['profileImageUrl'] ?? '';
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching player data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to show the dialog for editing the player's name
  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController(text: playerName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Enter your new name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  // Update Firestore with the new name
                  final User? user = _auth.currentUser;
                  if (user != null) {
                    await _firestore.collection('user_player').doc(user.uid).update({'Name': newName});
                    setState(() {
                      playerName = newName; // Update the local state
                    });
                  }
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Method to show the dialog for changing password
  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(labelText: 'Current Password'),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final User? user = _auth.currentUser;

                  if (user != null) {
                    // Re-authenticate user with current password
                    final credential = EmailAuthProvider.credential(email: playerEmail!, password: currentPasswordController.text);
                    await user.reauthenticateWithCredential(credential);

                    // Update password
                    await user.updatePassword(newPasswordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password changed successfully!')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to change password. Please check your current password.')),
                  );
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Info
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                          ? NetworkImage(profileImageUrl!)
                          : const NetworkImage('https://example.com/default_profile_image.png'), // Default image if no profile image is provided
                    ),
                    const SizedBox(height: 8),
                    Text(
                      playerName ?? 'Player Name',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      playerEmail ?? 'Player Email',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _showEditNameDialog, // Show edit name dialog
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Profile Options
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: _showChangePasswordDialog, // Show change password dialog
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Past Activities'),
                onTap: () {
                  // Navigate to past bookings or activities
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payment Methods'),
                onTap: () {
                  // Navigate to payment methods
                },
              ),
              ListTile(
                leading: const Icon(Icons.subscriptions),
                title: const Text('Subscription/Payment History'),
                onTap: () {
                  // Navigate to subscription or payment history
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification Settings'),
                onTap: () {
                  // Navigate to notification settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('App Settings'),
                onTap: () {
                  // Navigate to app settings (theme, language, privacy)
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                onTap: () {
                  // Navigate to help and support
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback & Ratings'),
                onTap: () {
                  // Navigate to feedback section
                },
              ),

              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login page
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
