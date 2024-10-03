class CourtOwnerData {
  final String uid;
  final String courtName;
  final String courtAddress;
  final String price;
  final String image;

  // Default constructor
  CourtOwnerData({
    required this.uid,
    required this.courtName,
    required this.courtAddress,
    required this.price,
    required this.image,
  });

  factory CourtOwnerData.fromMap(Map<String, dynamic> map) {
    return CourtOwnerData(
      uid: map['UID'],
      courtName: map['CourtName'],
      courtAddress: map['CourtAddress'],
      price: map['price'],
      image: map['image'],
    );
  }
}