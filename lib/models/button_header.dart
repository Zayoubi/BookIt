
import 'package:flutter/material.dart';

class ButtonHeader extends StatelessWidget {
  final String label;

  const ButtonHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15, left: 20, right: 20, bottom: 10),
          child: Center(
            child: Text(
              label, // Use the label parameter directly
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}