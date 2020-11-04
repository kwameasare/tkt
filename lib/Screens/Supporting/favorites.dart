import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tkt/constants.dart';
import 'package:tkt/widgets/category_item.dart';
import 'package:tkt/widgets/favorite_item.dart';
import '../../Database/database_helper.dart';
import 'package:tkt/utils.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

var favorites;
class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
   getFav();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ww = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    "FAVORITES",
                    style: kTitleStyle.copyWith(fontSize: ww * 0.05),
                  ),
                ),
              ],
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
                    onChanged: (string) {
                      // _debouncer.run(() {
                      //   setState(() {
                      //     filteredList= bankList
                      //         .where((u) => (u.bankName
                      //                 .toLowerCase()
                      //                 .contains(string.toLowerCase())))
                      //         .toList();

                      //   });
                      // });
                    },
                  ),
                ),
              ),

              // subtitle: Text(
              //   "Jakarta, Indonesia",
              //   style: kTitleStyle.copyWith(height: 1.5),
              // ),
              trailing: IconButton(
                icon: Icon(Feather.search),
                onPressed: () {},
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: FutureBuilder(
              future: getFav(),
             
              builder: (context, snapshot) {
                  return snapshot.hasData ?
                  new ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      print(snapshot.data.length);
                     return FavoriteItem(
                              name: snapshot.data[i]['title'],
                              organiser: snapshot.data[i]['organizer'],
                              banner: snapshot.data[i]['imageurl'],
                              location: snapshot.data[i]['location'],
                              description: snapshot.data[i]['description'],
                              pricing: "0",
                              // sessions: snapshot.data["sessions"],
                              // start_date: snapshots.data[index].start_date,
                              // start_time: snapshots.data[index].start_time
                            );
                    },
                  )
                  : Center(
                                child: CircularProgressIndicator(),
                              );
              },
            )

            )
          ],
        ))));
  }

   getFav() async {
    var db = new DatabaseHelper();
    favorites = await db.getAllFav();
    // favorites.forEach((fav) => print(fav));
    return favorites;
  }
}
