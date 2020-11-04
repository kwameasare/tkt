import 'package:flutter/material.dart';

import '../constants.dart';

class VerifyItem extends StatelessWidget {
  final String photo;
  final String phone;
  final String name;
  final String id;

  VerifyItem(
      {@required this.id,
      @required this.photo,
      @required this.phone,
      @required this.name});

  @override
  Widget build(BuildContext context) {
    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
          bottom: ww * 0.03, top: ww * 0.02, left: ww * 0.02, right: ww * 0.02),
      child: Container(
        width: ww * 0.95,
        height: ww * 0.12,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: ww * 0.07, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                    child: Center(
                      child: ClipRRect(
                         borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: Image.network(
                          photo,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.04,
                          fit: BoxFit.cover,
                        
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ww * 0.03),
                  Text(
                    name,
                    style: kTitleStyle,
                  ),
                ],
              ),
              Text(
                phone,
                style: kSubtitleStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
