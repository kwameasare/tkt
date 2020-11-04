import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/constants.dart';
import 'package:tkt/models/categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:tkt/widgets/category_item.dart';
import 'package:tkt/widgets/myevents_item.dart';

import '../../utils.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

var categories;
String kiv = "";
String ksp = "";
String keycode = "";

class MyEvents extends StatefulWidget {
  final String phone;
  const MyEvents(this.phone);
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  Future getValue() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      keycode = prefs.getString('keycode');
      kiv = prefs.getString('kiv');
      ksp = prefs.getString('ksp');
    });
    print(kiv);
  }

  void initState() {
    getValue().then((value) {
      setState(() {
        categories = _queryCategory();
      });
    });

    super.initState();
  }

  Future<List<Category>> _queryCategory() async {
    print(widget.phone);
    List<Category> arrayCategories = [];
    String url = "$baseUrl/events?filter[userPhone]=+233${widget.phone}";

    // if(widget.id == 0) {
    //   url = '$baseUrl/events';
    // } else {
    //   url = '$baseUrl/events?filter[event_category_id]==${widget.id}';
    // }

    print(url);
    Map<String, String> headers = {
      "kiv": kiv,
      "ksp": ksp,
      "keycode": keycode,
    };
    print(headers);

    Response response = await http.get(url, headers: headers);

    String abody = response.body;
    final cbody = json.decode(abody);

    if (response.statusCode == 200) {
      var convertedResponse = json.decode(response.body);
      print("starting array input");
      print(convertedResponse["data"]);
      convertedResponse["data"].forEach((data) {
        Category filterEvent = new Category(
          name: data["name"],
          organiser: data['organizer'],
          banner: data['banner'],
          location: data['venue'],
          description: data['description'],
          pricing: data['pricing'],
          sessions: data['sessions'].toList(),
          lat: data["venue_gps_lat"],
          lng: data["venue_gps_lng"],
          venue: data["venue"],
          ticket_types: data["ticket_types"].toList(),
          event_id: data["id"],

          //  start_date : data['sessions'][0]["start_date"],
          //  start_time : data['sessions'][0]["start_time"]
        );
        arrayCategories.add(filterEvent);
      });
      print(arrayCategories);
      print("this is number of list ${convertedResponse.length}");
    } else {
      print(response.body);
    }
    print("this is the array for event filter $arrayCategories");
    return arrayCategories;
  }

  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;
    const color1 = Color.fromRGBO(92, 72, 213, 0.8);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Feather.arrow_left,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Text(
                      "My Events",
                      style: kTitleStyle.copyWith(fontSize: ww * 0.05),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  // color: Colors.white,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.005,
                    top: MediaQuery.of(context).size.height * 0.005,
                  ),

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 6.0,
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5.0)
                      ]),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search For Events',
                        // prefixIcon: Icon(Icons.search),
                        hintStyle: kSubtitleStyle,
                        border: InputBorder.none,
                      ),
                      onChanged: (string) {},
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Feather.search),
                  onPressed: () {},
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: FutureBuilder(
                  future: categories,
                  builder: (BuildContext context, AsyncSnapshot snapshots) {
                    if (snapshots.hasData) {
                      return RefreshIndicator(
                        onRefresh: () {
                          setState(() {
                            categories = _queryCategory();
                          });

                          return categories;
                        },
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return MyEventsItem(
                              name: snapshots.data[index].name,
                              organiser: snapshots.data[index].organiser,
                              banner: snapshots.data[index].banner,
                              location: snapshots.data[index].location,
                              description: snapshots.data[index].description,
                              pricing: snapshots.data[index].pricing,
                              sessions: snapshots.data[index].sessions,
                              lat: snapshots.data[index].lat,
                              lng: snapshots.data[index].lng,
                              venue: snapshots.data[index].venue,
                              ticket_types: snapshots.data[index].ticket_types,
                              event_id: snapshots.data[index].event_id,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  buildCategoryItem(String name) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, left: 5.0),
      child: Center(
        child: InkWell(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.04,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6.0,
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5.0),
                ]),
            child: Center(
              child: Text(name,
                  style: TextStyle(
                    fontFamily: "nunito",
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
