import 'package:cloud_firestore/cloud_firestore.dart';

class Courts {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final double price;
  final bool availability;

  Courts({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.availability,
  });

  factory Courts.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Courts(
      id: doc.id,
      name: data['name'] ?? 'Unknown Court',
      location: data['location'] ?? 'Unknown Location',
      imageUrl: data['imageUrl'] ?? 'default_image.png', // Default image
      price: (data['price'] ?? 0).toDouble(),
      availability: data['availability'] ?? false,
    );
  }
}
