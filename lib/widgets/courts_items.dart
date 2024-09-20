import 'package:flutter/material.dart';
 import 'package:final_project/models/courts_details.dart';


class CourtsItems extends StatelessWidget {
  const CourtsItems({super.key});



  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child:  Column(
        children: [
         Padding(
           padding: const EdgeInsets.only(bottom:10),
           child: Container(
             height: 500,
             width: 120,
             decoration:  BoxDecoration(
               borderRadius: BorderRadius.circular(8),
               image: const DecorationImage(
                 fit: BoxFit.cover,
                   image: NetworkImage('https://en.reformsports.com/oxegrebi/2020/09/mini-futbol-sahasi-ozellikleri-ve-olculeri.jpg'),
                 
               )
             ),
           ),
         ),
          const Text('olympics',style: TextStyle(fontWeight: FontWeight.bold),),
          const Text('Tripoli,mia'),

        ],
      ),
    );
  }
}
