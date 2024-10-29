import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/users_screens/court_owner.dart';
import 'package:flutter/material.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating Feedbacks'),
        leading: IconButton(
          onPressed:(){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => const CourtOwner()
                )
            );
          } ,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedbacks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No ratings available.'));
          }

          final feedbacks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              final double rating = feedback['rating'] ?? 0.0; // Get rating
              final String playerName = feedback['playerName'] ?? 'Anonymous'; // Get player name

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(playerName),
                  subtitle: Text('Rating: ${rating.toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
