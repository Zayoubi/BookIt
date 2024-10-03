import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting dates

class PlayerReservationCheck extends StatelessWidget {
  final String playerId;

  const PlayerReservationCheck({super.key, required this.playerId, required List<CourtsBooking> reservations });

  // Method to fetch reservations from Firestore
  Stream<List<CourtsBooking>> getReservations() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('playerId', isEqualTo: playerId) // Query for specific playerId
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CourtsBooking.fromDocument(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Your Reservation')
    ),
      body: StreamBuilder<List<CourtsBooking>>(
        stream: getReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reservations = snapshot.data ?? [];

          return reservations.isNotEmpty
              ? ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final booking = reservations[index];

              // Formatting the date and time for better readability
              final String formattedStartTime =
              DateFormat('EEE, MMM d, yyyy, hh:mm a').format(booking.startTime);
              final String formattedEndTime =
              DateFormat('EEE, MMM d, yyyy, hh:mm a').format(booking.endTime);

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(booking.courtName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('From $formattedStartTime to $formattedEndTime'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          )
              : const Center(
            child: Text(
              'No reservations found.',
              style: TextStyle(fontSize: 18),
            ),
          ); // Fallback message for no reservations
        },
      ),
    );
  }
}
