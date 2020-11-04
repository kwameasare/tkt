import 'package:flutter/material.dart';
import 'package:tkt/widgets/small_button.dart';
import 'package:tkt/widgets/custom_list_tile.dart';
import '../../constants.dart';
class ProfilePage extends StatefulWidget {
  final String customerName;
  final String customerPhone;
  final String customerImage;

  const ProfilePage(this.customerName, this.customerPhone, this.customerImage);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool turnOnNotification = false;
  bool turnOnLocation = false;
    
    var color1 = Color.fromRGBO(92, 72, 213, 0.8);
    var color2 = Color.fromRGBO(161, 69, 219, 0.5);
  @override
  Widget build(BuildContext context) {
    var ww = MediaQuery.of(context).size.width;
    final double statusbarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    final double barHeight = ww * 0.12;
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.bubble_chart,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      decoration: BoxDecoration(
        color: color1
      ),
    ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Profile",
                    style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.055),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 3.0,
                                offset: Offset(0, 4.0),
                                color: Colors.black38),
                          ],
                          image: DecorationImage(image: NetworkImage(widget.customerImage),
                          fit: BoxFit.cover
                        ),
                      ),),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.customerName,
                            style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.040, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            widget.customerPhone,
                            style: kSubtitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.030, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SmallButton(btnText: "Edit"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Account",
                    style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.050),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          CustomListTile(
                            icon: Icons.location_on,
                            text: "Location",
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          // CustomListTile(
                          //   icon: Icons.visibility,
                          //   text: "Change Password",
                          // ),
                          // Divider(
                          //   height: 10.0,
                          //   color: Colors.grey,
                          // ),
                          // CustomListTile(
                          //   icon: Icons.shopping_cart,
                          //   text: "Shipping",
                          // ),
                          
                          CustomListTile(
                            icon: Icons.payment,
                            text: "Payment",
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Notifications",
                    style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.050),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "App Notification",
                                style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.040, fontWeight: FontWeight.w400),
                              ),
                              Switch(
                                activeColor: color1,
                                value: turnOnNotification,
                                onChanged: (bool value) {
                                  // print("The value: $value");
                                  setState(() {
                                    turnOnNotification = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Location Tracking",
                                style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.040, fontWeight: FontWeight.w400)
                              ),
                              Switch(
                                activeColor: color1,
                                value: turnOnLocation,
                                onChanged: (bool value) {
                                  // print("The value: $value");
                                  setState(() {
                                    turnOnLocation = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "Other",
                    style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.050),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Language", style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.040, fontWeight: FontWeight.w400)),
                            // SizedBox(height: 10.0,),
                            Divider(
                              height: 30.0,
                              color: Colors.grey,
                            ),
                            Text("Currency", style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.040, fontWeight: FontWeight.w400)),
                            // SizedBox(height: 10.0,),
                           
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
      ),
    );
  }
}