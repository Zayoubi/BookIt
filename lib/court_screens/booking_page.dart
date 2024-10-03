import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final now = DateTime.now();
  late BookingService mockBookingService; // BookingService object
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    mockBookingService = BookingService(
      userName: 'John Doe', // Example user
      userId: '12345',      // Example user ID
      serviceName: 'Terre Saint',
      serviceDuration: 60,
      bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
      bookingStart: DateTime(now.year, now.month, now.day, 8, 0),
      serviceId: '',        // Specify a serviceId if needed
    );
  }

  // Simulates fetching booking data from Firestore
  Stream<List<CourtsBooking>> getBookingStreamMock({required DateTime end, required DateTime start}) {
    return FirebaseFirestore.instance
        .collection('bookings')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start.toUtc())) // Ensure to use UTC
        .where('endTime', isLessThanOrEqualTo: Timestamp.fromDate(end.toUtc())) // Ensure to use UTC
        .snapshots()
        .map((snapshot) {
      List<CourtsBooking> bookings = snapshot.docs.map((doc) {
        return CourtsBooking.fromDocument(doc);
      }).toList();

      return bookings;
    });
  }

  // Converts the stream result from Firestore into a list of DateTimeRange objects
  List<DateTimeRange> convertStreamResultToDateTimeRanges({required dynamic streamResult}) {
    List<CourtsBooking> bookings = streamResult as List<CourtsBooking>;
    return bookings.map((booking) {
      return DateTimeRange(
        start: booking.startTime,
        end: booking.endTime,
      );
    }).toList();
  }

  Future<void> uploadBookingMock({required BookingService newBooking}) async {
    try {
      setState(() {
        isUploading = true; // Show loading indicator
      });

      // Simulate a delay
      await Future.delayed(const Duration(seconds: 1));

      // Create new reservation
      CourtsBooking newReservation = CourtsBooking(
        courtName: newBooking.serviceName,
        startTime: newBooking.bookingStart,
        endTime: newBooking.bookingEnd,
        playerId: '12345',
      );

      // Add reservation to Firestore
      await FirebaseFirestore.instance.collection('bookings').add(newReservation.toJson());

      setState(() {
        isUploading = false; // Hide loading indicator
      });

      Navigator.pop(context, newReservation); // Return the new reservation
    } catch (e) {
      setState(() {
        isUploading = false; // Hide loading indicator on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete booking. Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Calendar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
                  child: BookingCalendar(
                    bookingService: mockBookingService,
                    getBookingStream: getBookingStreamMock,
                    uploadBooking: uploadBookingMock,
                    pauseSlots: const [],
                    hideBreakTime: false,
                    convertStreamResultToDateTimeRanges: convertStreamResultToDateTimeRanges,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => uploadBookingMock(newBooking: mockBookingService),
                  child: const Text('Book Court'),
                ),
              ],
            ),
          ),
          if (isUploading)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
