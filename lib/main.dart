import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Screens/Auth/Login/login.dart';
import 'package:tkt/Screens/home.dart';

import 'Screens/onboarding/onboarding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      theme: ThemeData(),
      home: MyApp(),
    ));
  });
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ticketing',

//       home: Home(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _startup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    print(firstTime);

    if (firstTime != null && !firstTime) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      // First time
      prefs.setBool('first_time', false);
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => OnBoardingScreen()));
    }
  }

  @override
  void initState() {
    _startup();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
