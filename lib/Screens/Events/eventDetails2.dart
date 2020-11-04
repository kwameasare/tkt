import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Screens/Auth/SignUp/signup.dart';
import 'package:tkt/constants.dart';
import 'package:tkt/widgets/event_item.dart';
import '../../utils.dart';
import 'package:share/share.dart';
import 'buyTicket.dart';
import 'package:url_launcher/url_launcher.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class EventDetails2 extends StatefulWidget {
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

  const EventDetails2(
      this.name,
      this.organiser,
      this.banner,
      this.location,
      this.description,
      this.pricing,
      this.sessions,
      this.lat,
      this.lng,
      this.venue,
      this.ticket_types,
      this.event_id);
  //this.start_date, this.start_time
  @override
  _EventDetails2State createState() => _EventDetails2State();
}

class _EventDetails2State extends State<EventDetails2> {
  Location location = new Location();

  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  Future getValue() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      keycode = prefs.getString('keycode');
      kiv = prefs.getString('kiv');
      ksp = prefs.getString('ksp');
    });
    print(kiv);
  }

  void shownInSnackbar(String value) {
    _scaffoldKey2.currentState.showSnackBar(new SnackBar(
        content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Raleway",
        fontSize: 13,
      ),
    )));
  }

  @override
  void initState() {
    print(widget.sessions);

    getValue().then((value) {
      setState(() {
        categories = queryEvents();
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const color1 = Color.fromRGBO(92, 72, 213, 0.8);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey2,
      appBar: AppBar(
        actions: [
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  share(context);
                },
                child: Icon(Feather.share_2),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              ),
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  // share(context);
                  saveFav(widget.name, widget.description, widget.organiser,
                      widget.location, widget.banner);
                  shownInSnackbar("Successfully Favourited this Event.!!");
                },
                child: Icon(Feather.heart),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              ),
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  // share(context);
                },
                child: Icon(Feather.more_vertical),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              )
        ],
        backgroundColor: color1,
      ),
      body: Column(children: <Widget>[
        Container(
            width: ww,
            height: hh * 0.82,
            child: ListView(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Hero(
                  tag: widget.banner,
                  child: Center(
                    child: ClipRRect(
                      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      child: Image.network(
                        widget.banner,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: ww * 0.03, right: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child:
                                          Text(widget.name, style: kTitleStyle),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      widget.location != null
                                          ? Text(
                                              widget.location,
                                              style: kSubtitleStyle,
                                            )
                                          : Text(
                                              "ONLINE",
                                              style: kSubtitleStyle,
                                            )
                                    ],
                                  ),
                                ),
                                // Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //       children: <Widget>[
                                //         Text(
                                //           "by: ${widget.organiser}",
                                //           style: kSubtitleStyle
                                //         ),
                                //       ],
                                //     ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              widget.location != null
                                  ? InkWell(
                                      onTap: () async {
                                        var pos = await location.getLocation();

                                        print(pos);
                                        double user_lat = pos.latitude;
                                        double user_lng = pos.longitude;

                                        var url =
                                            'https://www.google.com/maps/dir/?api=1&origin=$user_lat,$user_lng&destination=${widget.lat},${widget.lng}&travelmode=driving&dir_action=navigate';
                                        _launchURL(url);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: ww * 0.05,
                                            vertical: ww * 0.02),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(Feather.arrow_right, size: 15),
                                            Text(
                                              '  LOCATE ON MAP',
                                              style: kTitleStyle.copyWith(
                                                  fontSize: ww * 0.02),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                            ])
                      ],
                    ),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: ww * 0.85,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(widget.description,
                                    style: kSubtitleStyle.copyWith(
                                        height: 1.9,
                                        color: Colors.blueGrey,
                                        fontSize: ww * 0.030)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: ww * 0.038, vertical: ww * 0.01),
                          children: <Widget>[
                            _buildPopUpImage(
                                'assets/images/stmarksbasilica.jpg'),
                            _buildPopUpImage('assets/images/gondola.jpg'),
                            _buildPopUpImage('assets/images/murano.jpg'),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Dated Sessions',
                            style: kTitleStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.sessions.length,
                            itemBuilder: (context, i) {
                              return buildIngredientItem(
                                  (widget.sessions[i]["start_date"])
                                      .substring(0, 10),
                                  (widget.sessions[i]["end_date"])
                                      .substring(0, 10));
                            },
                          )

                          // ListView(
                          //     scrollDirection: Axis.horizontal,
                          //     children: [
                          //       buildIngredientItem(
                          //           "Thu, 27 Aug", "Fri, 20 Sep."),
                          //       buildIngredientItem(
                          //           "Thu, 27 Aug", "Fri, 20 Sept."),
                          //       buildIngredientItem(
                          //           "Thu, 27 Aug", "Fri, 20 Sept."),
                          //       buildIngredientItem(
                          //           "Thu, 27 Aug", "Fri, 20 Sept."),
                          //       buildIngredientItem(
                          //           "Thu, 27 Aug", "Fri, 20 Sept."),
                          //     ])

                          ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: <Widget>[
                    //           Icon(Icons.calendar_today,
                    //               size: 30, color: Colors.black87),
                    //           Column(
                    //             children: <Widget>[
                    //               Text(
                    //                 " Saturday, January 26",
                    //                 style: TextStyle(
                    //                   fontSize: ww * 0.035,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontFamily: 'nunito',
                    //                 ),
                    //               ),
                    //               Text(
                    //                 " 5:00PM - 9:00PM PST",
                    //                 style: TextStyle(
                    //                   fontFamily: 'nunito',
                    //                 ),
                    //               )
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: hh * 0.025,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: <Widget>[
                    //           Icon(Icons.location_city,
                    //               size: 30, color: Colors.black87),
                    //           Column(
                    //             children: <Widget>[
                    //               Text(
                    //                 " Accra City, Ghana",
                    //                 style: TextStyle(
                    //                   fontSize: ww * 0.035,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontFamily: 'nunito',
                    //                 ),
                    //               ),
                    //               Text(
                    //                 " ${widget.location}",
                    //                 style: TextStyle(
                    //                   fontFamily: 'nunito',
                    //                 ),
                    //               )
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: hh * 0.025,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: <Widget>[
                    //           Icon(Icons.calendar_today,
                    //               size: 30, color: Colors.black87),
                    //           Column(
                    //             children: <Widget>[
                    //               Text(
                    //                 " GH₵60 - GH₵70          ",
                    //                 style: TextStyle(
                    //                   fontSize: ww * 0.035,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontFamily: 'nunito',
                    //                 ),
                    //               ),
                    //               Text(" Fees are raised slightly",
                    //                   style: TextStyle(
                    //                     fontFamily: 'nunito',
                    //                   ))
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: hh * 0.025,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: <Widget>[
                    //           Icon(Icons.description,
                    //               size: 30, color: Colors.black87),
                    //           Column(
                    //             children: <Widget>[
                    //               Text(
                    //                 " Refund Policy               ",
                    //                 style: TextStyle(
                    //                   fontSize: ww * 0.035,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontFamily: 'nunito',
                    //                 ),
                    //               ),
                    //               Text(
                    //                 "Tickets Not Refundable",
                    //                 style: TextStyle(
                    //                   fontFamily: 'nunito',
                    //                 ),
                    //               )
                    //             ],
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Refund Policy',
                            style: kTrailingStyle,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          EdgeInsets.only(left: ww * 0.001, bottom: ww * 0.10),
                      child: ExpansionTile(
                        title: Text(
                          "More",
                          style: kTitleStyle.copyWith(fontSize: ww * 0.04),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'The most important thing to know about a gig before you get there? What does the band sound like. Especially if its not a well-known band. Use the unlimited space to showcase the band and their discography. Bonus for name-dropping some famous familiars.',
                              style: kSubtitleStyle.copyWith(
                                  height: 1.9,
                                  color: Colors.blueGrey,
                                  fontSize: ww * 0.030),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: hh * 0.025,
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'More Like This.',
                            style: kTitleStyle,
                          ),
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text(widget.description,
                    //           style: kSubtitleStyle.copyWith(
                    //               height: 1.9,
                    //               color: Colors.blueGrey,
                    //               fontSize: ww * 0.030)),
                    //     ],
                    //   ),
                    // ),

                    new Divider(color: Colors.grey),
                    SizedBox(
                      height: hh * 0.025,
                    ),

                    Container(
                      height: MediaQuery.of(context).size.width * 0.60,
                      child: FutureBuilder(
                        future: categories,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshots) {
                          if (snapshots.hasData) {
                            return RefreshIndicator(
                              onRefresh: () {
                                setState(() {
                                  categories = queryEvents();
                                });

                                return categories;
                              },
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return EventItem(
                                    name: snapshots.data[index].name,
                                    organiser: snapshots.data[index].organiser,
                                    banner: snapshots.data[index].banner,
                                    location: snapshots.data[index].location,
                                    description:
                                        snapshots.data[index].description,
                                    pricing: snapshots.data[index].pricing,
                                    sessions: snapshots.data[index].sessions,
                                    lat: snapshots.data[index].lat,
                                    lng: snapshots.data[index].lng,
                                    venue: snapshots.data[index].venue,
                                    ticket_types:
                                        snapshots.data[index].ticket_types,
                                    // start_date: snapshots.data[index].start_date,
                                    // start_time: snapshots.data[index].start_time
                                  );
                                },
                                itemCount: snapshots.data.length,
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ])),
        Expanded(
          child: InkWell(
            onTap: () async {
              final SharedPreferences prefs = await _prefs;
              var phone = prefs.getString('phoneNumber');

              if (phone == null || phone == "") {
                showModalLoginSheet(context);
              } else {
                showTicketsModalSheet();
              }
            },
            child: Container(
                color: color1,
                child: Center(
                  child: Text(
                    "Tickets",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ww * 0.045,
                      fontFamily: 'nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
        ),
      ]),
    );
  }

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject();

    Share.share('check out my TicketGH website https://example.com',
        subject: 'Pay with smile 🥰 !',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  buildIngredientItem(String bgDate, String name) {
    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.only(right: ww * 0.02),
        child: InkWell(
          onTap: () {},
          child: Column(children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("FROM :",
                              style:
                                  kTrailingStyle.copyWith(fontSize: ww * 0.03)),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(bgDate,
                        style: kTitleStyle.copyWith(
                            fontSize: ww * 0.04, fontWeight: FontWeight.w300)),
                    SizedBox(height: 4.0),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("TO :",
                              style:
                                  kTrailingStyle.copyWith(fontSize: ww * 0.03)),
                        ],
                      ),
                    ),
                    Text(name,
                        textAlign: TextAlign.center,
                        style: kTitleStyle.copyWith(
                            fontSize: ww * 0.04, fontWeight: FontWeight.w300))
                  ],
                ))),
          ]),
        ));
  }

  buildTicketType(String id, String name) {
    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: ww * 0.05),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BuyTicket(id)));
            },
            child: Container(
              width: ww * 0.50,
              height: ww * 0.12,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6.0,
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5.0),
                  ]),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      name,
                      style: kTitleStyle,
                    ),
                    IconButton(
                      icon: Icon(Feather.arrow_right),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  launchMap() async {
    var mapSchema = 'geo:${widget.lat},${widget.lng}';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showTicketsModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              color: Colors.white,
              child: new Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.0035,
                      color: Colors.black12),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "Select Ticket Type",
                    style: kTitleStyle.copyWith(
                        fontSize: MediaQuery.of(context).size.width * 0.040),
                  ),
                ),
                Text(" EventQix ", style: kSubtitleStyle.copyWith(color: kRed)),
                SizedBox(height: MediaQuery.of(context).size.width * 0.052),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.50,

                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.ticket_types.length,
                      itemBuilder: (context, i) {
                        return buildTicketType((widget.ticket_types[i]["id"]),
                            (widget.ticket_types[i]["name"]));
                      },
                    ),

                    //                   child: ListView(
                    //   children: <Widget>[
                    //     buildTicketType("52555", "FREE"),
                    //      buildTicketType("52555", "FREE"),
                    //      buildTicketType("52555", "FREE")
                    //   ],

                    // ),
                  ),
                )
              ]));
        });
  }

  _buildPopUpImage(String s) {
    return Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.025),
        child: InkWell(
          onTap: () {},
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: AssetImage(s), fit: BoxFit.cover),
              ),
            )
          ]),
        ));
  }
}
