import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/court_screens/booking_page.dart';
import 'package:flutter/material.dart';
import 'package:final_project/court_screens/courts_data.dart'; // Import the Court class

class UserReservation extends StatelessWidget {
  final List<Courts> courts;


  const UserReservation({super.key, required this.courts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courts List'),
      ),
      body: ListView.builder(
        itemCount: courts.length,
        itemBuilder: (context, index) {
          final court = courts[index];
          return CourtCard(court: court);
        },
      ),
    );
  }
}

class CourtCard extends StatefulWidget {
  final Courts court;
  final Stream<QuerySnapshot> _courtStrem=FirebaseFirestore.instance.collection('user_courtowner').snapshots();

  CourtCard({super.key, required this.court});

  @override
  _CourtCardState createState() => _CourtCardState();
}

class _CourtCardState extends State<CourtCard> {
  bool isFavorited = false; // Track if the court is favorited
  int favoriteCount = 0; // Count of how many times it's favorited

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited; // Toggle the favorite state
      favoriteCount += isFavorited ? 1 : -1; // Update the count
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // Navigate to the booking page when the court card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookingPage(),
            ),
          );
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
                    backgroundImage: AssetImage(widget.court.imageUrl),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.court.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const Spacer(),

                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {

                    },
                  ),
                ],
              ),
            ),
            Image.asset(
              widget.court.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : null,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  Text('$favoriteCount'), // Display the favorite count
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {
                      _showCommentsBottomSheet(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      // Add sharing functionality
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: ${widget.court.location}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Price: \$${widget.court.price.toStringAsFixed(2)} per hour',
                    style: const TextStyle(fontSize: 14.0, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return CommentsSection(scrollController: scrollController);
          },
        );
      },
    );
  }
}

class CommentsSection extends StatefulWidget {
  final ScrollController scrollController;

  const CommentsSection({required this.scrollController, super.key});

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final List<Comment> comments = [
    Comment(username: 'user1', text: 'This court looks amazing!'),
    Comment(username: 'user2', text: 'Great location and reasonable price.'),
    Comment(username: 'user3', text: 'When can I book it?'),
  ];

  final TextEditingController _commentController = TextEditingController();

  void _addComment(String commentText) {
    setState(() {
      comments.add(Comment(username: 'CurrentUser', text: commentText));
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Comments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(comment.username[0].toUpperCase()),
                  ),
                  title: Text(comment.username),
                  subtitle: Text(comment.text),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/user_avatar.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      _addComment(_commentController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Comment {
  final String username;
  final String text;

  Comment({required this.username, required this.text});
}
