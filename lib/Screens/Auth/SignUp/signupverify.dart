import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pin_view/pin_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:tkt/Screens/home.dart';
import 'dart:convert';
import '../../../constants.dart';
import '../../../utils.dart';
import 'package:tkt/Screens/Auth/signup.dart';



class SignUpVerify extends StatefulWidget {

   String otpCode;
  String kiv;
   String ksp;
   String keycode;
  String phone;
  String screen;

   SignUpVerify(this.otpCode,this.kiv,this.ksp,this.keycode,this.phone, this.screen);
  @override
  _SignUpVerifyState createState() => _SignUpVerifyState();
}


Future<SharedPreferences> _prefs = SharedPreferences.getInstance();




// Future<String> _getProcessToken() async {
//   final SharedPreferences prefs = await _prefs;

//   var processkeykiv = prefs.getString(_processKeyKiv) ?? '';

//   print(processkeykiv);
  

//   return processkeykiv;
// }

class _SignUpVerifyState extends State<SignUpVerify> {

  
//   Future<bool> _setMobileToken(String token) async {
//   final SharedPreferences prefs = await _prefs;
  

//   return prefs.setString(_storageKeyMobileToken, token);
// }
  
rsendAgain() async {

  setState(() {

        _hideResendButton = true;
 
      });

  

  String url = '$baseUrl/auth/check-phone';
    Map<String, String> headers = {
      "kiv":widget.kiv, 
      "ksp":widget.ksp, 
      "keycode": widget.keycode,
      "osv": "0",

      


    };

    Map<String, dynamic> body = {'phoneNum': widget.phone, 'countryCode': 'gh'};
    Response response = await post(url, headers: headers, body: body);
    // check the status code for the result
    int statusCode = response.statusCode;

     String abody = response.body;

     var responseBody = response.body;

     final cbody = json.decode(responseBody);

     setState(() {
       widget.otpCode = cbody["OTP-CODE"];
     });

     print(cbody['statusCode']);

      print(abody);

}
  

  bool _hideResendButton = true ;

  Timer _timer;
  int _start = 60;

  void startTimer() {
     const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
    oneSec,
    (Timer timer) => setState(
      () {
        if (_start < 1) {
          timer.cancel();
          setState(() {
            _hideResendButton = !_hideResendButton ;
          });
        } else {
          _start = _start - 1;
        }
      },
    ),
  );
}

get _counter {

  return 
  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("0 : $_start" , style: TextStyle(
                fontFamily: "Montserrat", 
                fontSize : 25, 
                fontWeight: FontWeight.bold


              ),),

                  Text("secs", style: TextStyle(
                    fontFamily: "Montserrat"
                  ),)
                ],

              );


}


get _getResendButton {
    return new InkWell(
      child: new Container(
        height: 35,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(32)),
        alignment: Alignment.center,
        child: new Text(
          "Resend OTP",
          style:
              new TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Montserrat'),
        ),
      ),
      onTap: () async{

        rsendAgain();

        // setState(() {
        //   _start = 30;

        // });

        // do a .then promise function to set the _start to 10 seconds
        // then you start the startTimer() function;

        //  startTimer();
        
        // Resend you OTP via API or anything
      },
    );
  }

  @override
  void initState() {
    startTimer();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Stack(
        children: <Widget>[

          Container(

            alignment: Alignment.topLeft,
            
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: color1,
                // gradient: LinearGradient(
                //                   colors: [
                //                     Color.fromRGBO(143, 148, 251, 1),
                //                     Color.fromRGBO(143, 148, 251, .6),
                //                   ]
                //                 ),
            ),
           

              

            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25, left: 20),
              child: Column (
                
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Verification", style: TextStyle(
                    color: Colors.white, 
                    fontFamily: "Futura", 
                    fontSize: 40, 
                    fontWeight: FontWeight.bold

                  ),
                  ), 
                    ],

                  ),

                  Row (
                    children: <Widget>[
                      Text("Kindly input the OTP number sent to your ", style: TextStyle(
                    color: Colors.white, 
                    fontFamily: "Raleway", 
                    

                  ),
                  ),
                    ],
                  ) ,
                  

                  Row(
                    children: <Widget>[
                      Text("Phone via SMS to access your account", style: TextStyle(
                    color: Colors.white, 
                    fontFamily: "Raleway", 

                  ),)
                    ]
                  )

                ],
              ),
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.only(top: 35, left: 15),
           
              
             
          //       child: GestureDetector(
          //         onTap: () => {

          //         },
          //         child: Icon(Icons.arrow_back_ios, color: Colors.white,)
          //         )
               
              
          // ),

          SingleChildScrollView(
                      child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              // color: Colors.white, 
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),

              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))

              ),

              child:Column(

                children: <Widget>[


              

              SizedBox(height: 20),

              _hideResendButton ? _counter : _getResendButton,

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Text("0 : $_start" , style: TextStyle(
              //   fontFamily: "Montserrat", 
              //   fontSize : 25, 
              //   fontWeight: FontWeight.bold


              // ),),

              //     Text("secs", style: TextStyle(
              //       fontFamily: "Montserrat"
              //     ),)
              //   ],

              // ),

             Container(
               width: 300,

               child:  PinView (
								count: 6, // describes the field number
								dashPositions: [1,2,3,4,5], // positions of dashes, you can add multiple
								autoFocusFirstField: true, // defaults to true
								margin: EdgeInsets.all(2), // margin between the fields
								obscureText: true, // describes whether the text fields should be obscure or not, defaults to false
								style: TextStyle (
									// style for the fields
									fontSize: 40.0,
									fontWeight: FontWeight.w500,
                  fontFamily: "Raleway"
								),
								dashStyle: TextStyle (
									// dash style
									fontSize: 18.0,
									color: Colors.blueGrey
								),
								submit: (String pin) async {
									// when all the fields are filled
									// submit function runs with the pin
									// print(pin);

                  

                  if (pin == widget.otpCode) {

                    print("Phone verified");

                    if(widget.screen == "login") {
                      setNumber(widget.phone.substring(widget.phone.length - 9));
                      Navigator.push(
                      context,
              // you change it to OTP() view for IOS version
                      new MaterialPageRoute(builder: (context) => Home())
                  );

                    } else {
                      Navigator.push(
                      context,
              // you change it to OTP() view for IOS version
                      new MaterialPageRoute(builder: (context) => Signup(widget.phone)),
                  );
                    }
                    

                  }

                  else {

                    showMessage(context, "The code you entered is wrong!!", "OOPS ... ");
                   

      
                    throw new Exception("sorry you couldnt login");
                  }

                  print(pin);
								}		
							),

             ),

                  

              //    Padding(
              //      padding: EdgeInsets.only(top: 8),
              //      child: Container(
              // width: 320,

              
              // padding: EdgeInsets.all(2.0),
              // child: TextField(
              // autocorrect: true,
              // decoration: InputDecoration(
              //   hintText: '2-2-1-4-7-1',
              //   prefixIcon: Icon(Icons.phone_iphone),
              //   hintStyle: TextStyle(color: Colors.blueGrey, fontFamily: "Montserrat", fontSize: 14),
              //   filled: true,
              //   fillColor: Colors.white70,
                
              //   enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
              //       borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    
              //      ),
              //   focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
              //       borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    
              //   ),
              // ),),
              //      ),
              //    ),

                 Container(
                   margin: EdgeInsets.only(top: 2), 
                   width: 320, 
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: <Widget>[
                       Text("", style: TextStyle(
                         fontFamily: "Raleway", 
                         fontSize: 11, 
                         color: Colors.blueGrey
                       ),)
                     ]
                   ),
                 ),
            
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(

                      onTap:(() => {
                        }),
                      child: Container(
                                     alignment: Alignment.center,
                          width : 180, 
                          height: 45, 
                          
                          decoration: BoxDecoration(
                            borderRadius : BorderRadius.all(Radius.circular(22.5)),
                            color : color1,
                          ),

                          child: Text("Verify", style : kTitleStyle.copyWith(fontSize: 18, color: Colors.white)),
                          
                        ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: <Widget> [
                        Text("", style: TextStyle(
                          
                          fontFamily: "Raleway" , 
                          fontSize: 12

                        ),), 
                        // Text('Register Now', style: TextStyle(
                        //   color: Colors.red, 
                        //   fontFamily: "Montserrat" , 
                        //   fontSize: 12
                        // ),)
                      ]
                    ),
                  ),
                  
                ],

                

              ),

            ),
          )

          

      ],
      )
      

    );
  }

  @override
void dispose() {
  _timer.cancel();
  super.dispose();
}


}