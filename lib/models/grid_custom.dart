import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridCustom extends StatelessWidget {
  final IconData icondash;
  final String gridtitle;
  final String route;

  const GridCustom({
    super.key,
    required this.icondash,
    required this.gridtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green[200],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icondash, size: 40),
              Text(gridtitle, style: GoogleFonts.roboto(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}