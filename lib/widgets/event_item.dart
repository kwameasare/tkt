import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tkt/Screens/Events/eventDetails2.dart';
import 'package:tkt/constants.dart';

class EventItem extends StatelessWidget {
  

   final String name;
  final String organiser;
  final String banner;
  final String location;
  final String description;
  final String pricing;
  final List sessions;
  final String lat;
  final String lng; 
  final String venue;
  final List ticket_types;
  final String event_id;
  // final String start_date;
  // final String start_time;

  EventItem(
    {
      @required this.name,
      @required this.organiser,
       @required this.banner,
        @required this.location,
       @required this.description,
        @required this.pricing, 
        @required this.sessions,
        @required this.lat,
        @required this.lng,
        @required this.venue,
         @required this.ticket_types,
        @required this.event_id,  
        //this.start_date, this.start_time
    }
  );

  @override

  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;

    // var dated = DateFormat.yMMMMd("en_US").format(DateTime.parse("${start_date.toString().substring(0, 10)}"));
    return  GestureDetector(
      onTap: () {
        
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetails2(
                                name,organiser,banner, location, description, pricing, sessions, lat, lng, venue,ticket_types,event_id
                                    //start_date, start_time
                                    )));
                              
                            
      },
          child: Container (
                         margin: EdgeInsets.all(10.0),
                         width: ww * 0.6,
                         height: hh * 0.25,
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
                                    borderRadius : BorderRadius.circular(12.0)
                                 ),
                                 child: Padding(
                                   padding: EdgeInsets.all(10.0),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Row(
                                         children: <Widget>[
                                           SizedBox(height: 40,),
                                         ],
                                       ),
                                       Row(
                                         children: <Widget>[
                                           Text("${name.toUpperCase()}",
                                            maxLines: 2, style: kTitleStyle.copyWith(fontSize: ww * 0.032, fontWeight: FontWeight.w300)
                                           
                                           ),
                                         ],
                                       ),
                                       Row(
                    children: <Widget>[
                      Text(
                        "THU 27, JAN.",
                        style: kTitleStyle.copyWith(color: kBlue),
                      ),
                      Spacer(),
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              kRedAccent,
                              kRed,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kRedAccent.withOpacity(.7),
                              blurRadius: 15.0,
                              spreadRadius: 0.2,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.bookmark,
                          color: kWhite,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                                       

                                      //  Text("$dated", style: TextStyle(
                                      //    color: Colors.grey,
                                      //    fontFamily: 'nunito',
                                      //                         fontSize: ww * 0.030
                                      //  ),
                                       
                                      //  ),
                                     
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
                                      child: Image.network(
                                        "$banner",
                                        height: hh * 0.16, 
                                     width: ww * 0.6,
                                     
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
  
}