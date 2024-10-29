import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/court_screens/courts_data.dart';
import 'package:final_project/models/court_card.dart';
import 'package:flutter/material.dart';

class UserReservation extends StatelessWidget {
  const UserReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(child: Text('Edit Court')),
      //   automaticallyImplyLeading: false,
      //
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courts').snapshots(),
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check for errors in the snapshot
          if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}'); // Log the error
            return const Center(child: Text('Error loading courts'));
          }

          // Check if there is data and if the documents are not empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No courts available'));
          }

          // Map Firestore documents to Court objects
          final courts = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
            print('Document data: $data'); // Log the document data

            return Courts(
              id: doc.id,
              name: data['courtName'] ?? 'Unknown Court', // Default value if null
              location: data['courtAddress'] ?? 'Unknown Location', // Default value if null
              imageUrl: data['courtImageUrl'] ?? '', // Default empty string if null
              price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0, // Default value if parse fails
              availability: data['courtAvailability'] ?? false, // Default value if null
            );
          }).toList();

          // Build the list of CourtCard widgets
          return ListView.builder(
            itemCount: courts.length,
            itemBuilder: (context, index) {
              final court = courts[index];
              return CourtCard(court: court);
            },
          );
        },
      ),
    );
  }
}
