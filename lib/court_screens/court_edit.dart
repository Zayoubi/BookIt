import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/users_screens/court_owner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CourtEdit extends StatefulWidget {
  const CourtEdit({super.key});

  @override
  State<CourtEdit> createState() => _CourtEditState();
}

class _CourtEditState extends State<CourtEdit> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String? _currentUserId;
  String _courtName = '';
  String _courtAddress = '';
  String _courtPhoneNumber = '';
  String _courtPrice = '';
  bool _courtAvailability = true;
  File? _selectedImage;
  String? _courtImageUrl;  // Field for displaying the current image URL
  bool _isLoading = true;
  bool _hasEditPermission = false;
  final List<String> _courtOwnerUids = [];

  @override
  void initState() {
    super.initState();
    _retrieveCurrentUserAndCourts();
  }

  // Retrieve user ID and court data
  Future<void> _retrieveCurrentUserAndCourts() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _currentUserId = user.uid;
      }

      final querySnapshot = await _firestore.collection('courts').get();
      for (var doc in querySnapshot.docs) {
        var courtData = doc.data();
        if (courtData.containsKey('UID')) {
          _courtOwnerUids.add(courtData['UID']);
        }
      }

      if (_currentUserId != null && _courtOwnerUids.contains(_currentUserId)) {
        setState(() {
          _hasEditPermission = true;
        });
        await _fetchCourtData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are not authorized to edit this court.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error retrieving user or courts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch existing court data
  Future<void> _fetchCourtData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('courts')
          .where('UID', isEqualTo: _currentUserId)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var courtData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _courtName = courtData['courtName'] ?? '';
          _courtAddress = courtData['courtAddress'] ?? '';
          _courtPhoneNumber = courtData['courtPhoneNumber'] ?? '';
          _courtPrice = courtData['price']?.toString() ?? '';
          _courtAvailability = courtData['courtAvailability'] ?? true;
          _courtImageUrl = courtData['courtImageUrl'];  // Retrieve current image URL
        });
      }
    } catch (e) {
      print('Error fetching court data: $e');
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('court_images/$_currentUserId/${DateTime.now().toIso8601String()}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Update court data in Firestore
  Future<void> _updateCourtData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (_selectedImage != null) {
          _courtImageUrl = await _uploadImage(_selectedImage!);  // Update with new image URL
        }

        final updatedCourtData = {
          'courtName': _courtName,
          'courtAddress': _courtAddress,
          'courtPhoneNumber': _courtPhoneNumber,
          'price': double.tryParse(_courtPrice) ?? 0.0,
          'courtAvailability': _courtAvailability,
          'courtImageUrl': _courtImageUrl,
        };

        await _firestore.collection('courts')
            .where('UID', isEqualTo: _currentUserId)
            .limit(1)
            .get()
            .then((querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            await querySnapshot.docs.first.reference.update(updatedCourtData);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Court details updated successfully!')),
            );
          }
        });

        Navigator.pushNamed(context, '/courtownerpage');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update court details: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Edit Court')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/courtownerpage');
          },
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_hasEditPermission
          ? const Center(child: Text('No permission to edit this court.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _courtName,
                  decoration: const InputDecoration(labelText: 'Court Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter court name'
                      : null,
                  onSaved: (value) => _courtName = value!,
                ),
                TextFormField(
                  initialValue: _courtAddress,
                  decoration: const InputDecoration(labelText: 'Court Address'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter court address'
                      : null,
                  onSaved: (value) => _courtAddress = value!,
                ),
                TextFormField(
                  initialValue: _courtPhoneNumber,
                  decoration: const InputDecoration(labelText: 'Court Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter phone number'
                      : null,
                  onSaved: (value) => _courtPhoneNumber = value!,
                ),
                TextFormField(
                  initialValue: _courtPrice,
                  decoration: const InputDecoration(labelText: 'Court Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter court price'
                      : null,
                  onSaved: (value) => _courtPrice = value!,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Availability: '),
                    Switch(
                      value: _courtAvailability,
                      onChanged: (value) {
                        setState(() {
                          _courtAvailability = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : (_courtImageUrl != null
                        ? Image.network(_courtImageUrl!, fit: BoxFit.cover)
                        : const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 50,
                    )),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateCourtData,
                    child: const Text('Update Court Data'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
