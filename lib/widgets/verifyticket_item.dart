import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tkt/Screens/Events/eventDetails2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tkt/Screens/Events/myeventdetails.dart';
import 'package:tkt/Screens/Pages/verify_ticket.dart';
import 'package:tkt/utils.dart';

class VerifyTicketItem extends StatelessWidget {
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

  VerifyTicketItem({
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
    
    // this.start_date, this.start_time
  });

  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;
    const color1 = Color.fromRGBO(92, 72, 213, 0.8);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);
    DateFormat format = DateFormat("dd-MM-yyyy", 'en_US');
    //  var dated = DateFormat.yMMMMd("en_US").format(DateTime.parse("${start_date.toString().substring(0, 10)}"));

    
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey1.currentState.showSnackBar(new SnackBar(
        content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Raleway",
        fontSize: 13,
      ),
    )));
  }
  
    return Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyTicket(phone)));
            //, start_date, start_time
          },
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Stack(children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                height: 130.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: ww * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text("$dated-$start_time", style: TextStyle(
                          //   color: Colors.red,
                          //   fontFamily: 'nunito',
                          //   fontSize: ww * 0.032,
                          //   fontWeight: FontWeight.bold
                          // ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            child: Text(
                              "$name",
                              style: TextStyle(
                                fontFamily: 'nunito',
                                fontSize: ww * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                '',
                                style: TextStyle(
                                  fontSize: .0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "$organiser",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'nunito',
                          fontSize: ww * 0.025,
                        ),
                      ),

                      Text(
                        "$location",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'nunito',
                          fontSize: ww * 0.030,
                        ),
                      ),
                      // _buildRatingStars(5),
                      SizedBox(height: 20.0),
                      /*  Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(5.0),
                                              width: 100.0,
                                              decoration: BoxDecoration(
                                                color:color1,
                                                borderRadius: BorderRadius.circular(100.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                               "$pricing",
                                                style: TextStyle(
                                                   fontFamily: 'nunito',
                                                                  fontSize: ww * 0.030, 
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            
                                          ],
                                        ) */
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 15.0,
                bottom: 15.0,
                child: Hero(
                  tag: "$banner",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      "$banner",
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ]),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blue,
                icon: Icons.archive,
                onTap: () => showInSnackBar('Archive'),
              ),
              IconSlideAction(
                caption: 'Like',
                color: Colors.indigo,
                icon: Icons.favorite,
                onTap: () {
                      saveFav(name, description, organiser, location, banner);
                      // showInSnackBar('Favorited');
                }
              ),
            ],
            
          ),
        ),
      ],
    );
  }

 
}
