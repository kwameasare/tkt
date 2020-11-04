import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Screens/home.dart';
import 'package:uuid/uuid.dart';
import '../../constants.dart';
import '../../utils.dart';

String _keycode = "";
const String _storageKeycode = "keycode";
const String _storagekiv = "kiv";
const String _storageksp = "ksp";

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> _setKeyCode(String ticketKeycode) async {
    final SharedPreferences prefs = await _prefs;
    print(ticketKeycode);
    return prefs.setString(_storageKeycode, ticketKeycode);
  }

  Future<bool> _setKiv(String ticketKeycode) async {
    final SharedPreferences prefs = await _prefs;
    print(ticketKeycode);
    return prefs.setString(_storagekiv, ticketKeycode);
  }

  Future<bool> _setKsp(String ticketKeycode) async {
    final SharedPreferences prefs = await _prefs;
    print(ticketKeycode);
    return prefs.setString(_storageksp, ticketKeycode);
  }

  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  _makeSecurityRequest() async {
    String url = '$baseUrl/auth/sec';

    Map<String, dynamic> body = {'keyCode': _keycode};
    Response response = await post(url, body: body);
    // check the status code for the result
    int statusCode = response.statusCode;
    var responseBody = response.body;

    final cbody = json.decode(responseBody);

    print(cbody);

    if (statusCode == 200) {
      _setKiv(cbody['kiv']);
      _setKsp(cbody['ksp']);
    } else {
      throw new Exception("Network busy..try again next time");
    }

    // this API passes back the id of the new item added to the body
    String abody = response.body;

    print(abody);
  }

  Future createKeyCode() {
    var uuid = Uuid();
    setState(() {
      // _keycode = "${uuid.v1()}";
    });
    return _setKeyCode("1234567");
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color.fromRGBO(92, 72, 213, 0.8) : Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  void initState() {
    createKeyCode().then((value) {
      _makeSecurityRequest();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(color: Colors.white
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   stops: [0.1, 0.4, 0.7, 0.9],
              //   colors: [
              //     Color(0xFF3594DD),
              //     Color(0xFF4563DB),
              //     Color(0xFF5036D5),
              //     Color(0xFF5B16D0),
              //   ],
              // ),
              ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: kTitleStyle.copyWith(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: hh * 0.7,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/onboarding0.png',
                                ),
                                height: hh * 0.45,
                                width: ww,
                              ),
                            ),
                            SizedBox(height: hh * 0.018),
                            Text('Discover popular\nevents nearby.',
                                style: kTitleStyle.copyWith(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Text('Stay up on the latest for popular events.',
                                style: kTitleStyle.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w300)
                                // style: kSubtitleStyle,
                                ),
                            SizedBox(height: hh * 0.012),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/onboarding1.png',
                                ),
                                height: hh * 0.45,
                                width: ww,
                              ),
                            ),
                            SizedBox(height: hh * 0.018),
                            Text(
                              'Take a Selfies\nfor verification.',
                              style: kTitleStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text('A smarter and faster way.',
                                style: kTitleStyle.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w300)
                                // style: kSubtitleStyle,
                                ),
                            SizedBox(height: hh * 0.012),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/onboarding2.png',
                                ),
                                height: hh * 0.45,
                                width: ww,
                              ),
                            ),
                            Text(
                              'Get Verified\ninstantly at events.',
                              style: kTitleStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: hh * 0.012),
                            Text('Facial verification at all Events.',
                                style: kTitleStyle.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w300)
                                // style: kSubtitleStyle,
                                ),
                            SizedBox(height: hh * 0.012),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: kTitleStyle.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: hh * 0.10,
              width: double.infinity,
              color: Color.fromRGBO(92, 72, 213, 0.8),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => Home()),
                  )
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Get started',
                      style: kTitleStyle.copyWith(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
