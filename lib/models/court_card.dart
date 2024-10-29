import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/court_screens/booking_page.dart';
import 'package:final_project/court_screens/courts_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CourtCard extends StatelessWidget {
  final Courts court;

  const CourtCard({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (court.availability) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingPage(),
              ),
            );
          } else {
            _showUnavailableDialog(context);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(court.imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    court.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Image.network(
              court.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Availability: ${court.availability ? "Available" : "Unavailable"}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    'Location: ${court.location}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Price: \$${court.price.toStringAsFixed(2)} per hour',
                    style: const TextStyle(fontSize: 14.0, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: 0,
                    allowHalfRating: true,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 25,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      _sendRatingToFirebase(rating); // Call to send rating to Firebase
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnavailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Court Unavailable'),
          content: const Text('This court is currently unavailable.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  // Function to send rating to Firebase
  void _sendRatingToFirebase(double rating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'rating': rating, // Add the rating here
          'playerName': user.displayName ?? 'ziad',
        });
        if (kDebugMode) {
          print('Rating submitted: $rating');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error submitting rating: $e');
        }
      }
    }
  }

  Future<void> _sendFeedback(BuildContext context, String feedback, String courtId, String playerName) async {
    if (kDebugMode) {
      print('Sending feedback: $feedback, Court ID: $courtId, Player Name: $playerName');
    }

    try {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'courtId': courtId,
        'feedback': feedback,
        'playerName': playerName,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully')),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting feedback: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: $e')),
      );
    }
  }
}
