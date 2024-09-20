import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration:const BoxDecoration(
        color: Colors.green,
      ) ,
      child: const Column(
        children: [
          Text('admin')
        ],
      ),
    );
  }
}
