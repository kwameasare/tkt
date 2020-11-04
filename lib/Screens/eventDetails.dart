import 'package:flutter/material.dart';

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: ww,
            height: hh,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: hh * 0.06, left: ww * 0.02),
              child: Column(
                children: <Widget> [
                  Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                                          child: Container(
                        width: 25, 
                        height: 25,
                        
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.grey[300],
                        ),
                        child: Center(child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 15 ))
                      ),
                    )

                ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[


                ],)

                ]
                

              ),
            ),
          ), 

          Container(
            width: ww, 
            height: hh / 3,
            margin: EdgeInsets.only(top: hh * 2/3),
            decoration :BoxDecoration(
              color: Color.fromRGBO(229,213,252, 1), 
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
          ),

          child: Column(
            children: <Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(top: hh * 0.01),
                    child: Container(
                      width: ww * 0.2, 
                      height: hh * 0.01, 
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(162,158,239, 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                  )

              ],), 

              Padding(
                padding: EdgeInsets.only(top: hh * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ww / 3, 
                      height: hh * 0.05, 
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color.fromRGBO(92, 72, 213, 0.5)
                      ), 
                      child: Center (
                        child: Text("Top Comments", style: TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold
                        ),)
                      ,)
                    ),

                    Container(
                      width: ww / 3, 
                      height: hh * 0.05, 
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        // color: Color.fromRGBO(92, 72, 213, 0.8)
                      ), 
                      child: Center (
                        child: Text("Latest Comments", style: TextStyle(
                          color: Colors.black87,
                           fontWeight: FontWeight.bold
                        ),)
                      ,)
                    )

                ],),
              )
            ]
          ),
          )
        ],
      ),
      
    );
  }
}