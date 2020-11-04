import 'package:flutter/material.dart';
import '../constants.dart';
class CustomListTile extends StatelessWidget {
  
  final IconData icon;
  final String text;

  CustomListTile({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.blue,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            "$text",
            style: kTitleStyle.copyWith(fontSize: MediaQuery.of(context).size.width * 0.040, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}