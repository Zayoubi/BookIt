import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  const ReservationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header (Profile Picture and Username)
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'), // Add a profile image
            ),
            title: Text('username', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Location or additional info'),
            trailing: Icon(Icons.more_vert),
          ),

          // Post Image
          Image.asset(
            'assets/pitch.jpg', // Add a post image
            fit: BoxFit.cover,
            height: 300.0,
            width: double.infinity,
          ),

          // Post Actions (Like, Comment, Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'username ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: 'This is the caption of the post. #hashtag #flutter',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // Post Timestamp
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Text(
              '2 hours ago',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}




