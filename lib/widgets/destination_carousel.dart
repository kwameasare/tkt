import 'package:flutter/material.dart';
import 'package:tkt/Screens/Events/eventDetails2.dart';
import 'package:tkt/Screens/eventDetails.dart';
import '../models/destination_model.dart';

class DestinationCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
           
            
            Container(
               height: ww * 0.55,
              //  color: Colors.blue,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: destinations.length,
                 itemBuilder: (BuildContext context, int index) {
                   Destination destination = destinations[index];
                   return InkWell(
                     onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetails2(destination.imageUrl, destination.city)));
                     },
                                        child: Container (
                       margin: EdgeInsets.all(10.0),
                       width: ww * 0.6,
                      //  color: Colors.red,
                       child : Stack(
                         alignment: Alignment.topCenter,
                         children : <Widget> [
                           Positioned(
                             bottom: 15.0,
                               child: Container(
                               height: hh * 0.15,
                               width: ww *0.6,
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                  borderRadius : BorderRadius.circular(5.0)
                               ),
                               child: Padding(
                                 padding: EdgeInsets.all(10.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.end,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     SizedBox(height: 20,),
                                     Text(destination.city, style: TextStyle(
                                       color: Colors.black,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: 'nunito',
                                                            fontSize: ww * 0.040
                                     ),
                                     
                                     ),

                                     Text("12 December, 2019", style: TextStyle(
                                       color: Colors.grey,
                                       fontFamily: 'nunito',
                                                            fontSize: ww * 0.030
                                     ),
                                     
                                     ),
                                   
                                 ],
                                 ),
                               )
                               ),
                           ),
                             Container(
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                  ),
                                  ]

                                  ),
                              child: Stack(
                               children: <Widget>[
                                 ClipRRect(
                                   borderRadius: BorderRadius.circular(5.0),
                                    child: Image(height: hh * 0.16, 
                                   width: ww * 0.6,
                                   image:AssetImage(destination.imageUrl),
                                   fit: BoxFit.cover,
                                   ),
                                 )
                               ],
                             )
                             )
                         ]
                       )
                        
                       ),
                   );
                 }
               ),
               )

          ],
          
    );
  }
}