import 'package:flutter/material.dart';
// import '../models/courts_details.dart';

class CourtItem extends StatelessWidget {
  final String courtName;
  final String location;
  final String price;
   final String imageUrl;

     const CourtItem(
       this.courtName,
       this.location,
       this.price,
       this.imageUrl,
       {super.key}
       );



  void selectCourt(){}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 7,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 250,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(location, style: const TextStyle(
                                    color: Colors.grey, fontSize: 16)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 30),
                                child: Text(
                                  courtName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                            
                            child: Stack(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 20,top: 35),
                                  child: Icon(Icons.favorite_border,color: Colors.grey,),
                                ),
                        
                                  Text(price,
                                      style: const TextStyle(
                                          color: Colors.white,
                                        fontSize: 16
                                      ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  }