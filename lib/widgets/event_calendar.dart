import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class EventCalendarApp extends StatefulWidget {
  const EventCalendarApp({super.key});

  @override
  _EventCalendarAppState createState() => _EventCalendarAppState();
}

class _EventCalendarAppState extends State<EventCalendarApp> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Post>> _posts = {}; // To hold posts locally

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Fetch posts from Firestore
  }

  // Fetch posts from Firestore
  void _fetchPosts() async {
    CollectionReference postRef = FirebaseFirestore.instance.collection('posts');

    // Listen to changes in Firestore posts collection
    postRef.snapshots().listen((snapshot) {
      Map<DateTime, List<Post>> fetchedPosts = {};
      for (var doc in snapshot.docs) {
        DateTime postDate = (doc['date'] as Timestamp).toDate();
        String title = doc['title'];
        String description = doc['description'];

        if (fetchedPosts[postDate] == null) {
          fetchedPosts[postDate] = [];
        }
        fetchedPosts[postDate]?.add(Post(title: title, description: description, date: postDate));
      }

      setState(() {
        _posts = fetchedPosts;
      });
    });
  }

  // Function to add a new post to Firestore
  Future<void> _addPost(String title, String description) async {
    if (_selectedDay == null || title.isEmpty) return;

    await FirebaseFirestore.instance.collection('posts').add({
      'date': _selectedDay,
      'title': title,
      'description': description,
    });
  }

  // Function to display a dialog for adding posts
  void _showAddPostDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Enter post title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Enter post description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addPost(titleController.text, descriptionController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        title: const Text('Event Organizer Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 10),
          _selectedDay != null && _posts[_selectedDay] != null
              ? Expanded(
            child: ListView.builder(
              itemCount: _posts[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                final post = _posts[_selectedDay]![index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.description),
                  onTap: () {
                    _showPostDetails(post);
                  },
                );
              },
            ),
          )
              : const Center(child: Text('No posts for this day')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show post details
  void _showPostDetails(Post post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(post.title),
          content: Text(post.description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Post model class
class Post {
  final String title;
  final String description;
  final DateTime date;

  Post({required this.title, required this.description, required this.date});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MaterialApp(
    home: EventCalendarApp(),
  ));
}
