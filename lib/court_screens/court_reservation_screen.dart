import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CourtOwnerBookingList extends StatefulWidget {
  @override
  _CourtOwnerBookingListState createState() => _CourtOwnerBookingListState();
}

class _CourtOwnerBookingListState extends State<CourtOwnerBookingList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<Booking>>> _getBookingsGroupedByDay() async {
    QuerySnapshot snapshot = await _firestore.collection('bookings').get();
    List<Booking> bookings = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Booking(
        id: doc.id,
        startTime: (data['startTime'] as Timestamp).toDate(),
        endTime: (data['endTime'] as Timestamp).toDate(),
        playerId: data['playerId'] ?? 'Unknown',
      );
    }).toList();

    Map<String, List<Booking>> bookingsByDay = {};
    for (var booking in bookings) {
      String dayKey = DateFormat('yyyy-MM-dd').format(booking.startTime);
      if (bookingsByDay.containsKey(dayKey)) {
        bookingsByDay[dayKey]!.add(booking);
      } else {
        bookingsByDay[dayKey] = [booking];
      }
    }

    return bookingsByDay;
  }

  void _showChangeTimeDialog(Booking booking) {
    final TextEditingController startTimeController =
    TextEditingController(text: DateFormat('hh:mm a').format(booking.startTime));
    final TextEditingController endTimeController =
    TextEditingController(text: DateFormat('hh:mm a').format(booking.endTime));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Booking Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startTimeController,
                decoration: const InputDecoration(labelText: 'Start Time (hh:mm a)'),
              ),
              TextField(
                controller: endTimeController,
                decoration: const InputDecoration(labelText: 'End Time (hh:mm a)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  DateTime newStartTime = DateFormat('hh:mm a').parse(startTimeController.text);
                  DateTime newEndTime = DateFormat('hh:mm a').parse(endTimeController.text);

                  await _firestore.collection('bookings').doc(booking.id).update({
                    'startTime': Timestamp.fromDate(newStartTime),
                    'endTime': Timestamp.fromDate(newEndTime),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking time changed successfully!')),
                  );

                  Navigator.of(context).pop();
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to change booking time.')),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Booking'),
          content: const Text('Are you sure you want to delete this booking?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _firestore.collection('bookings').doc(bookingId).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking deleted successfully!')),
                );
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Delete'),
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
        title: Text('Court Bookings'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, List<Booking>>>(
        future: _getBookingsGroupedByDay(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookingsByDay = snapshot.data!;

          return ListView.builder(
            itemCount: bookingsByDay.length,
            itemBuilder: (context, index) {
              String dayKey = bookingsByDay.keys.elementAt(index);
              List<Booking> bookingsForDay = bookingsByDay[dayKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Header
                  Container(
                    padding: const EdgeInsets.all(10),

                    child: Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(DateTime.parse(dayKey)),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
                    ),
                  ),
                  // List of bookings for that day
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bookingsForDay.length,
                    itemBuilder: (context, bookingIndex) {
                      final booking = bookingsForDay[bookingIndex];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          title: Text(
                            'Player: ${booking.playerId}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Start: ${DateFormat('hh:mm a').format(booking.startTime)}\n'
                                'End: ${DateFormat('hh:mm a').format(booking.endTime)}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showChangeTimeDialog(booking),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteBooking(booking.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class Booking {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String playerId;

  Booking({required this.id, required this.startTime, required this.endTime, required this.playerId});
}
