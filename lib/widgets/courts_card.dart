// import 'package:final_project/court_owner_screens/courts_data.dart';
// import 'package:final_project/player_screens/booking_page.dart';
// import 'package:flutter/material.dart';
// import 'package:final_project/court_owner_screens//court_datadart'; // Import the Court model
// import 'package:final_project/player_screens/booking_page.dart'; // Import the BookingPage class to navigate to
//
// class CourtCard extends StatelessWidget {
//   final Court court;
//
//   const CourtCard({super.key, required this.court});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: () {
//           // Navigate to the booking page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BookingPage(court: court),
//             ),
//           );
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Court Name and Location
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 court.name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ),
//             // Court Image
//             Image.asset(
//               court.imageUrl,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 200,
//             ),
//             // Additional Details
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Location: ${court.location}\nPrice: \$${court.price.toStringAsFixed(2)} per hour',
//                 style: const TextStyle(fontSize: 14.0),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
