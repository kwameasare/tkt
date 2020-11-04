import 'dart:convert';
import 'dart:wasm';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/imageUploadModel.dart';

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'dart:async';

import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../utils.dart';
import '../../Screens/home.dart';

ProgressDialog pr;

const String _storageSessions = "recurringSessions";
const String _storagePricing = "recurringPricing";

const kGoogleApiKey = "API key here";
String sessionsArrayString = "";
String pricingArrayString = "";
// map locations data
double lattitude;
double longitude;
String venue = "";

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

String kiv = "";
String ksp = "";
String keycode = "";

// CHOSEN conditions that are dependent on others
String chosenCategory = "";
bool chosenLocationType = false;
bool chosenEventType = false;
bool chosenPricing = false;
bool _validate = false;
bool _allDayToggle = false;

String errorResponse = "";

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  Future getSecurityValue() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      keycode = prefs.getString('keycode');
      kiv = prefs.getString('kiv');
      ksp = prefs.getString('ksp');
    });
    print(kiv);
  }

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  List<Object> images = List<Object>();
  List<File> imageFilesArray = List<File>();

  Future<File> _imageFile;
//  List<Asset> images = List<Asset>();
  String _error;
  // image upload
  File _image;
  File _image0;
  File _image1;
  File _image2;

  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Raleway",
        fontSize: 13,
      ),
    )));
  }

  final _eventTitleController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventTimeController = TextEditingController();
  final _eventPriceController = TextEditingController();
  final _eventVenueController = TextEditingController();
  final _eventLatController = TextEditingController();
  final _eventLongController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventOrganiserController = TextEditingController();
  final _startDateController = TextEditingController();
  final _stopDateController = TextEditingController();
  final _eventCapacityController = TextEditingController();
  final _eventPhysicalAddressController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _stopTimeController = TextEditingController();
  final _ticketAmountController = TextEditingController();
  final _ticketTypeController = TextEditingController();
  final _eventGHPOSTController = TextEditingController();

  final dateFormat = DateFormat("yyyy-MM-dd");
  final format = DateFormat("HH:mm");
  String validateEventInfo(String value) {
    if (value.length < 2) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

// dropdown list
  List<String> _locations = ['VENUE', 'ONLINE']; // Option 2
  String _selectedLocation; // Option 2

  // dropdown list
  List<String> _pricing = ['PAID', 'FREE']; // Option 2
  String _selectedpricing;
  bool chosenPaid = false; // Option 2

  // dropdown list
  List<String> _categories = [
    'Conference',
    'Seminar',
    'Tradeshow',
    'Convention',
    'Festival',
    'Concert',
    'Dinner',
    'Workshop',
    'Rally',
    'Other',
    'Party',
    'Tour',
    'Tournament'
  ]; // Option 2
  String _selectedcategory; // Option 2

  List<String> _ticketTypes = ['RECURRING', 'SINGLE']; // Option 2
  String _selectedTicketType; // Option 2

  _createGridBoxes() {
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  @override
  void initState() {
    setPricingtoPreference("");
    setSessionstoPreference("");

    getSecurityValue();
    super.initState();
    // have to override the sharedpreference method
    _createGridBoxes();
  }

  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    final hh = MediaQuery.of(context).size.height;

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(message: 'Showing some progress...');

    //Optional
    pr.style(
      message: 'Creating Ticket...',
      borderRadius: 5,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(strokeWidth: 4.0),
      elevation: 10,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black,
          fontSize: ww * 0.01,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: ww * 0.03,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w600),
    );

    void _showDialogMessage(String message) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)), //this right here
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    //  image: DecorationImage(
                    //           image: AssetImage('assets/images/back4.jpg'),
                    //           fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 6.0,
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5.0)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "TicketGH",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "nunito",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 4.0,
                                          color: Color.fromRGBO(
                                              92, 72, 213, 0.8))),
                                  child: Icon(Icons.close,
                                      color: Colors.black, size: 18))),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            message,
                            style: TextStyle(
                              fontFamily: "nunito",
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color:
                                            Color.fromRGBO(92, 72, 213, 0.8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          "Back",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              fontFamily: "nunito"),
                                        ),
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }

    _createEvent(File imageFile) async {
      final SharedPreferences prefs = await _prefs;
      var phone = prefs.getString('phoneNumber');
      print(phone);

      if (phone == null || phone.length == 0) {
        showModalLoginSheet(context);
        return;
      }

      // process supporting images
      // should find a better way of doin this
      print("showing images now");
      // images.removeWhere((item) => item == "Add Image");
      print(_image0);

      //  if(images.length != 0 ) {
      //   for (int i = 0; i < images.length; i++) {
      //         print(images[i]);
      //         imageFilesArray.add(images[i]);
      //   }

      // }
      setState(() {
        sessionsArrayString = "${prefs.getString(_storageSessions) ?? ''}";
        pricingArrayString = "${prefs.getString(_storagePricing) ?? ''}";
      });
      print(sessionsArrayString);

      // validation
      /* if(_eventTitleController.text.length == 0 ) {
      _showDialogMessage("Name of Event cannot be empty");
        }
        if(_eventDescriptionController.text.length == 0 ) {
      _showDialogMessage("Description cannot be empty");
        }
        if(_eventOrganiserController.text.length == 0 ) {
      _showDialogMessage("Event Organiser cannot be empty");
        } */
      if (imageFile == null) {
        _showDialogMessage("Please select image banner for Event");

        return;
      }

      pr.show();

      // switch case for selected category
      switch (_selectedcategory) {
        case "Conference":
          setState(() {
            chosenCategory = "1";
          });
          break;
        case "Seminar":
          setState(() {
            chosenCategory = "2";
          });
          break;

        case "TradeShow":
          setState(() {
            chosenCategory = "3";
          });
          break;
        case "Convention":
          setState(() {
            chosenCategory = "4";
          });
          break;
        case "Festival":
          setState(() {
            chosenCategory = "5";
          });
          break;
        case "Concert":
          setState(() {
            chosenCategory = "6";
          });
          break;
        case "Dinner":
          setState(() {
            chosenCategory = "7";
          });
          break;
        case "Workshop":
          setState(() {
            chosenCategory = "8";
          });
          break;
        case "Rally":
          setState(() {
            chosenCategory = "9";
          });
          break;

        case "Other":
          setState(() {
            chosenCategory = "10";
          });
          break;
        case "Party":
          setState(() {
            chosenCategory = "11";
          });
          break;
        case "Tour":
          setState(() {
            chosenCategory = "12";
          });
          break;
        case "Tournament":
          setState(() {
            chosenCategory = "6";
          });
          break;
      }
      print(chosenCategory);
      print(sessionsArrayString);

      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse("$baseUrl/events");

      // if(sessionsArrayString.length == 0) {
      //   _showDialogMessage("Please Sessions for Recurring Events");
      // } else {

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('banner', stream, length,
          filename: basename(imageFile.path));
      request.headers["kiv"] = kiv;
      request.headers["ksp"] = ksp;
      request.headers["keyCode"] = keycode;
      request.fields["phone"] = "$phone";
      request.fields["name"] = _eventTitleController.text;
      request.fields["description"] = _eventDescriptionController.text;
      request.fields["organizer"] = _eventOrganiserController.text;

      request.fields["event_category_id"] = chosenCategory;
      request.fields["pricing"] = _selectedpricing;
      request.fields["capacity"] = _eventCapacityController.text;

      request.fields["type"] = _selectedTicketType;
      request.fields["location"] = _selectedLocation;

      if (_selectedLocation == "VENUE") {
        request.fields["venue"] = "$venue";
        request.fields["venue_physical_address"] =
            _eventPhysicalAddressController.text;
        request.fields["venue_ghana_post_gps"] = _eventGHPOSTController.text;
        request.fields["venue_gps_lng"] = "$longitude";
        request.fields["venue_gps_lat"] = "$lattitude";
      }
      if (_selectedTicketType == "RECURRING") {
        request.fields["sessions"] = sessionsArrayString;
      }

      if (_selectedpricing == "PAID") {
        request.fields["ticket_types"] = pricingArrayString;
      }

      if (_selectedTicketType == "SINGLE") {
        request.fields["sessions[0][start_date]"] = _startDateController.text;
        request.fields["sessions[0][start_time]"] = _startTimeController.text;
        request.fields["sessions[0][end_date]"] = _stopDateController.text;
        request.fields["sessions[0][end_time]"] = _stopTimeController.text;
      }

      // request.files.add(
      //   http.MultipartFile(
      //     'images[0]',
      //     http.ByteStream(DelegatingStream.typed(_image0.openRead())),
      //     await _image0.length(),
      //     filename: basename(_image0.path),
      //   ),
      // );
      if (_image0 != null) {
        List<int> imageBytes = _image0.readAsBytesSync();
        print(imageBytes);
        String base64Image = base64Encode(imageBytes);
        print('string is');
        print(base64Image);
        print("You selected gallery image : " + _image0.path);
        request.fields["image1"] = "$base64Image";
      }

      if (_image1 != null) {
        List<int> imageBytes = _image1.readAsBytesSync();
        print(imageBytes);
        String base64Image = base64Encode(imageBytes);
        print('string is');
        print(base64Image);
        print("You selected gallery image : " + _image1.path);
        request.fields["image2"] = "$base64Image";
      }

      if (_image2 != null) {
        List<int> imageBytes = _image2.readAsBytesSync();
        print(imageBytes);
        String base64Image = base64Encode(imageBytes);
        print('string is');
        print(base64Image);
        print("You selected gallery image : " + _image2.path);
        request.fields["image3"] = "$base64Image";
      }

      // for( int i = 0; i < imageFilesArray.length; i++ ) {
      //       request.files.add(
      //         http.MultipartFile(
      //           'images[$i]',
      //           http.ByteStream(DelegatingStream.typed(imageFilesArray[i].openRead())),
      //           await imageFilesArray[i].length(),
      //           filename: basename(imageFilesArray[i].path),
      //         ),
      //       );
      //  }

      //   request.fields["sessions[0][start_date]"] =  _startDateController.text;
      //  request.fields["sessions[0][start_time]"] =  _startTimeController.text;

      //  request.fields["sessions[0][end_date]"] =  _stopDateController.text;
      //  request.fields["sessions[0][end_time]"] =  _stopTimeController.text;

      //  request.fields["sessions[1][start_date]"] = "2020-10-15";
      // request.fields["sessions[1][start_time]"] = "06:00";

      // request.fields["sessions[1][end_date]"] = "2020-12-15";
      //  request.fields["sessions[1][end_time]"] = "06:00";

      //contentType: new MediaType('image', 'png'));
      // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request

      request.files.add(multipartFile);
      print(request);
      var response = await request.send();

      print(response.statusCode);
      try {
        response.stream.transform(utf8.decoder).listen((value) {
          // print(value);
          // print(json.decode(value)["data"]);
          // setState(() {
          //   errorResponse = json.decode(value)["data"];
          // });
          // _createGridBoxes();

          if (response.statusCode == 200) {
            pr.hide();
            showInSnackBar("Successfully created Event");
          } else {
            pr.hide();
            showInSnackBar(json.decode(value)["data"]);
          }
        });
      } catch (e) {
        pr.hide();
        // _createGridBoxes();

      }

      print(response.statusCode);
      print(errorResponse);

      // } catch(exception) {
      //   throw Exception(exception);

      // }
      // }
    }

    const color1 = Color.fromRGBO(92, 72, 213, 0.8);
    const color2 = Color.fromRGBO(161, 69, 219, 0.5);
    void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();
      _imageFile.then((file) async {
        if (file == null) {
          return;
        }
        setState(() {
          ImageUploadModel imageUpload = new ImageUploadModel();
          imageUpload.isUploaded = false;
          imageUpload.uploading = false;
          imageUpload.imageFile = file;
          imageUpload.imageUrl = '';
          images.replaceRange(index, index + 1, [imageUpload]);

          if (index == 0) {
            setState(() {
              _image0 = imageUpload.imageFile;
            });
          }
          if (index == 1) {
            setState(() {
              _image1 = imageUpload.imageFile;
            });
          }
          if (index == 2) {
            setState(() {
              _image2 = imageUpload.imageFile;
            });
          }
        });

        print(images);
      });
    }

    Future _onAddImageClick(int index) async {
      setState(() {
        _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
        getFileImage(index);
      });
    }

    Widget buildGridView() {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1,
        children: List.generate(images.length, (index) {
          if (images[index] is ImageUploadModel) {
            ImageUploadModel uploadModel = images[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    child: Image.file(uploadModel.imageFile,
                        width: ww * 0.30, height: ww * 0.30, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 5,
                    top: 0,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          images.replaceRange(index, index + 1, ['Add Image']);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (images[index] == null) {
            return Card(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _onAddImageClick(index);
                },
              ),
            );
          } else {
            return Card(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _onAddImageClick(index);
                },
              ),
            );
          }
        }),
      );
    }

    // _createEvent() async {

    //   String url = '$baseUrl/events';
    //   Map<String, String> headers = {
    //     "kiv":"$_kiv",
    //     "ksp":"$_ksp",
    //     "keycode": "$_keycode",

    //   };

    //   Map<String, dynamic> body = {
    //     'phone':"$_phone",
    //     'name': _eventTitleController.text,
    //     'description':'What a glorious God',
    //     'organizer':'Nakroteck',
    //     'banner':_image,
    //     'event_category_id':'6',
    //     'pricing':'PAID',
    //     'location':'VENUE',
    //     'venue':'Accra International Confrence Centre',
    //     'type':'RECURRING',
    //     'venue':'Kumasi Culture Centre',
    //     'venue_physical_address':'Accra,Ghana',
    //     'venue_ghana_post_gps':'Accra International Confrence Centre',
    //     'venue_gps_lat':'0',
    //     'venue_gps_lng':'22',
    //     'capacity':'45',
    //     'sessions[0][start_date]':'2020-06-15',
    //     'sessions[0][start_time]':'06:00',
    //     'sessions[0][end_date]':'2020-06-16',
    //     'sessions[0][end_time]':'17:30',
    //     'sessions[1][start_date]':'2020-06-16',
    //     'sessions[1][end_date]':'2020-06-17',
    //     'sessions[1][start_time]':'07:00',
    //     'sessions[1][end_time]':'09:00',
    //     'images[0][name]':'Abena',
    //     'images[0][path]':'@/C:/Users/AMUN-RA/Desktop/event-images/abena.png',
    //     'images[1][name]':'Baaba',
    //     'images[1][path]':'@/C:/Users/AMUN-RA/Desktop/event-images/Baaba.jpg',
    //     'ticket_types[0][name]':'Ordinary',
    //     'ticket_types[0][amount]':'20',
    //     'ticket_types[1][name]':'VIP',
    //     'ticket_types[1][amount]':'50'
    //     };

    //     print(body);

    //    Response response = await post(url, headers: headers, body: body);

    //     var rspBody = response.body;
    //     print(rspBody);
    //     var decodedbody = json.decode(rspBody);
    //    print(decodedbody);
    //   // check the status code for the result

    //   var statuscode = decodedbody['statusCode'];

    //   if (statuscode == "200") {

    //   }

    //   else if(statuscode == "500" ) {

    //   }

    // }

    // Future<void> loadAssets() async {
    //   setState(() {
    //     images = List<Asset>();
    //   });

    //   List<Asset> resultList;
    //   String error;

    //   try {
    //     resultList = await MultiImagePicker.pickImages(
    //       maxImages: 300,
    //     );
    //   } on Exception catch (e) {
    //     error = e.toString();
    //   }

    //   // If the widget was removed from the tree while the asynchronous platform
    //   // message was in flight, we want to discard the reply rather than calling
    //   // setState to update our non-existent appearance.
    //   if (!mounted) return;

    //   setState(() {
    //     images = resultList;
    //     if (error == null) _error = 'No Error Dectected';
    //   });
    // }

    Future<bool> _onBackPressed() {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home()));
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("New Event",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "nunito",
                    fontSize: ww * 0.052)),
          ),
          body: Container(
            width: ww,
            height: hh,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: ww * 0.04,
                      left: ww * 0.08,
                      right: ww * 0.08,
                      bottom: ww * 0.08),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Basic Details",
                            style: TextStyle(
                                fontSize: ww * 0.062,
                                fontWeight: FontWeight.w700,
                                fontFamily: "nunito",
                                color: Colors.black87),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "This section contains the basic details of your event.",
                            style: TextStyle(
                                fontFamily: "nunito",
                                fontSize: ww * 0.032,
                                color: Colors.blueGrey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ww * 0.08, right: ww * 0.08, bottom: ww * 0.08),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "EVENT TITLE",
                            style: TextStyle(
                                fontSize: ww * 0.042,
                                fontFamily: "nunito",
                                color: Colors.blueGrey),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: ww * 0.82,
                            height: hh * 0.075,
                            padding: EdgeInsets.only(top: ww * 0.02),
                            child: TextFormField(
                              controller: _eventTitleController,
                              // autocorrect: true,
                              decoration: InputDecoration(
                                errorText: _validate
                                    ? validateEventInfo(
                                        _eventTitleController.text)
                                    : null,
                                hintText: 'Name of Event',
                                hintStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "nunito",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                                filled: true,
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide:
                                      BorderSide(color: color1, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ww * 0.04),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "DESCRIPTION",
                              style: TextStyle(
                                  fontSize: ww * 0.042,
                                  fontFamily: "nunito",
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: ww * 0.82,
                            height: hh * 0.075,
                            padding: EdgeInsets.only(top: ww * 0.02),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: _eventDescriptionController,
                              // autocorrect: true,
                              decoration: InputDecoration(
                                errorText: _validate
                                    ? validateEventInfo(
                                        _eventDescriptionController.text)
                                    : null,
                                hintText: 'Event Description',
                                hintStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "nunito",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                                filled: true,
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide:
                                      BorderSide(color: color1, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ww * 0.04),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "ORGANISER",
                              style: TextStyle(
                                  fontSize: ww * 0.042,
                                  fontFamily: "nunito",
                                  color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: ww * 0.82,
                            height: hh * 0.075,
                            padding: EdgeInsets.only(top: ww * 0.02),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: _eventOrganiserController,
                              // autocorrect: true,
                              decoration: InputDecoration(
                                errorText: _validate
                                    ? validateEventInfo(
                                        _eventOrganiserController.text)
                                    : null,
                                hintText: 'Event Organiser',
                                hintStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "nunito",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                                filled: true,
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide:
                                      BorderSide(color: color1, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ww * 0.08),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "CATEGORY",
                                  style: TextStyle(
                                      fontFamily: "nunito",
                                      fontSize: ww * 0.03,
                                      color: Colors.blueGrey),
                                ),
                                Text(
                                  "CAPACITY",
                                  style: TextStyle(
                                      fontFamily: "nunito",
                                      fontSize: ww * 0.03,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: ww * 0.40,
                                  height: hh * 0.075,
                                  padding: EdgeInsets.only(top: ww * 0.02),
                                  decoration: BoxDecoration(),
                                  child: DropdownButton(
                                    hint: Text(
                                      'Choose Ticket Category',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "nunito",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035),
                                    ),
                                    // Not necessary for Option 1
                                    value: _selectedcategory,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedcategory = newValue;
                                      });
                                    },
                                    items: _categories.map((category) {
                                      return DropdownMenuItem(
                                        child: new Text(category,
                                            style: TextStyle(
                                                fontFamily: "nunito")),
                                        value: category,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                  width: ww * 0.35,
                                  height: hh * 0.075,
                                  padding: EdgeInsets.only(top: ww * 0.02),
                                  child: TextFormField(
                                    controller: _eventCapacityController,

                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],

                                    // autocorrect: true,
                                    decoration: InputDecoration(
                                      errorText: _validate
                                          ? validateEventInfo(
                                              _eventCapacityController.text)
                                          : null,
                                      hintText: 'Attendees',
                                      hintStyle: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "nunito",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035),
                                      filled: true,
                                      fillColor: Colors.white70,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: color1, width: 0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])),
                      Padding(
                        padding: EdgeInsets.only(top: ww * 0.04),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "LOCATION",
                                  style: TextStyle(
                                      fontFamily: "nunito",
                                      fontSize: ww * 0.03,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: ww * 0.27,
                                  height: hh * 0.075,
                                  padding: EdgeInsets.only(top: ww * 0.02),
                                  decoration: BoxDecoration(),
                                  child: DropdownButton(
                                    hint: Text(
                                      'Choose location',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "nunito",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035),
                                    ),
                                    // Not necessary for Option 1
                                    value: _selectedLocation,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedLocation = newValue;
                                      });

                                      if (newValue == "VENUE") {
                                        setState(() {
                                          chosenLocationType = true;
                                        });
                                      } else {
                                        setState(() {
                                          chosenLocationType = false;
                                          venue = "";
                                          lattitude = null;
                                          longitude = null;
                                        });
                                      }
                                    },
                                    items: _locations.map((location) {
                                      return DropdownMenuItem(
                                        child: new Text(location,
                                            style: TextStyle(
                                                fontFamily: "nunito")),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                chosenLocationType
                                    ? venue.length == 0
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlacePicker(
                                                    apiKey:
                                                        kGoogleApiKey, // Put YOUR OWN KEY here.
                                                    onPlacePicked: (result) {
                                                      setState(() {
                                                        lattitude = result
                                                            .geometry
                                                            .location
                                                            .lat;
                                                        longitude = result
                                                            .geometry
                                                            .location
                                                            .lng;
                                                        venue = result
                                                            .formattedAddress;
                                                      });
                                                      print(result
                                                          .formattedAddress);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    initialPosition:
                                                        kInitialPosition,
                                                    useCurrentLocation: true,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                                width: ww * 0.32,
                                                height: hh * 0.045,
                                                padding: EdgeInsets.only(
                                                    top: ww * 0.02),
                                                decoration: BoxDecoration(
                                                    color: color1,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 6.0,
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 5.0)
                                                    ]),
                                                child: Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: ww * 0.012),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text("CHOOSE FROM MAP",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "nunito",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: ww *
                                                                    0.030)),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  width: ww * 0.45,
                                                  height: hh * 0.045,
                                                  padding: EdgeInsets.only(
                                                      top: ww * 0.02,
                                                      left: 10,
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[50],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 6.0,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 5.0)
                                                      ]),
                                                  /* put row to edit address */
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: ww * 0.012),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                                "$venue",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        "nunito",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: ww *
                                                                        0.030)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: ww * 0.03),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PlacePicker(
                                                            apiKey:
                                                                kGoogleApiKey, // Put YOUR OWN KEY here.
                                                            onPlacePicked:
                                                                (result) {
                                                              setState(() {
                                                                lattitude = result
                                                                    .geometry
                                                                    .location
                                                                    .lat;
                                                                longitude = result
                                                                    .geometry
                                                                    .location
                                                                    .lng;
                                                                venue = result
                                                                    .formattedAddress;
                                                              });
                                                              print(result
                                                                  .formattedAddress);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            initialPosition:
                                                                kInitialPosition,
                                                            useCurrentLocation:
                                                                true,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Center(
                                                        child: Icon(Icons.edit,
                                                            size: ww * 0.04,
                                                            color:
                                                                Colors.grey)),
                                                  ))
                                            ],
                                          )
                                    : Container(),
                              ],
                            ),
                            chosenLocationType
                                ? Padding(
                                    padding: EdgeInsets.only(top: ww * 0.04),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "VENUE NAME",
                                              style: TextStyle(
                                                  fontFamily: "nunito",
                                                  fontSize: ww * 0.03,
                                                  color: Colors.blueGrey),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: ww * 0.82,
                                              height: hh * 0.075,
                                              padding: EdgeInsets.only(
                                                  top: ww * 0.02),
                                              child: TextFormField(
                                                controller:
                                                    _eventPhysicalAddressController,
                                                // autocorrect: true,
                                                decoration: InputDecoration(
                                                  errorText: _validate
                                                      ? validateEventInfo(
                                                          _eventPhysicalAddressController
                                                              .text)
                                                      : null,
                                                  hintText: 'Physical Address',
                                                  hintStyle: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontFamily: "nunito",
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.5),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                    borderSide: BorderSide(
                                                        color: color1,
                                                        width: 0.5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(top: ww * 0.04),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "GHANA POST GPS (OPTIONAL)",
                                                style: TextStyle(
                                                    fontFamily: "nunito",
                                                    fontSize: ww * 0.03,
                                                    color: Colors.blueGrey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: ww * 0.82,
                                              height: hh * 0.075,
                                              padding: EdgeInsets.only(
                                                  top: ww * 0.02),
                                              child: TextFormField(
                                                controller:
                                                    _eventGHPOSTController,
                                                // autocorrect: true,
                                                decoration: InputDecoration(
                                                  errorText: _validate
                                                      ? validateEventInfo(
                                                          _eventGHPOSTController
                                                              .text)
                                                      : null,
                                                  hintText: 'Physical Address',
                                                  hintStyle: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontFamily: "nunito",
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035),
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.5),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)),
                                                    borderSide: BorderSide(
                                                        color: color1,
                                                        width: 0.5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: ww * 0.08),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "EVENT TYPE",
                                  style: TextStyle(
                                      fontFamily: "nunito",
                                      fontSize: ww * 0.03,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: ww * 0.27,
                                  height: hh * 0.075,
                                  padding: EdgeInsets.only(top: ww * 0.02),
                                  child: DropdownButton(
                                    hint: Text(
                                      'Ticket Type',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: "nunito",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035),
                                    ),
                                    // Not necessary for Option 1
                                    value: _selectedTicketType,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedTicketType = newValue;
                                      });
                                      if (newValue == "RECURRING") {
                                        setState(() {
                                          chosenEventType = true;
                                        });
                                      } else {
                                        setState(() {
                                          chosenEventType = false;
                                        });
                                      }
                                    },
                                    items: _ticketTypes.map((ticket) {
                                      return DropdownMenuItem(
                                        child: new Text(ticket,
                                            style: TextStyle(
                                                fontFamily: "nunito")),
                                        value: ticket,
                                      );
                                    }).toList(),
                                  ),
                                ),
                                chosenEventType
                                    ? GestureDetector(
                                        onTap: () async {
                                          List<SessionEntry> persons =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SOF(),
                                            ),
                                          );
                                          if (persons != null)
                                            persons.forEach(print);
                                        },
                                        child: Container(
                                            width: ww * 0.32,
                                            height: hh * 0.045,
                                            padding:
                                                EdgeInsets.only(top: ww * 0.02),
                                            decoration: BoxDecoration(
                                                color: color1,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 6.0,
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 5.0)
                                                ]),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: ww * 0.012),
                                                child: Column(
                                                  children: <Widget>[
                                                    Text("ADD SESSION",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "nunito",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                ww * 0.030)),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      )
                                    : Container()
                              ],
                            ),
                          ])),
                      chosenEventType
                          ? Container()
                          : Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: ww * 0.04),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Date",
                                        style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: ww * 0.040,
                                            color: Colors.blueGrey),
                                      ),
                                      MergeSemantics(
                                          child: Row(
                                        children: <Widget>[
                                          Text(
                                            "All day Event  ",
                                            style: TextStyle(
                                                fontFamily: "nunito",
                                                fontSize: ww * 0.040,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          CupertinoSwitch(
                                              value: _allDayToggle,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  _allDayToggle = value;
                                                });
                                                if (_allDayToggle == true) {}
                                              })
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: ww * 0.04),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "STARTS AT",
                                            style: TextStyle(
                                                fontFamily: "nunito",
                                                fontSize: ww * 0.03,
                                                color: Colors.blueGrey),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: ww * 0.35,
                                            height: hh * 0.075,
                                            padding:
                                                EdgeInsets.only(top: ww * 0.02),
                                            child: DateTimeField(
                                              format: dateFormat,
                                              controller: _startDateController,
                                              decoration: InputDecoration(
                                                errorText: _validate
                                                    ? validateEventInfo(
                                                        _eventDateController
                                                            .text)
                                                    : null,
                                                hintText: 'Choose Date',
                                                suffixIcon:
                                                    Icon(Icons.calendar_today),
                                                hintStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontFamily: "nunito",
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035),
                                                filled: true,
                                                fillColor: Colors.white70,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: color1,
                                                      width: 0.5),
                                                ),
                                              ),
                                              onShowPicker:
                                                  (context, currentValue) {
                                                return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(1900),
                                                    initialDate: currentValue ??
                                                        DateTime.now(),
                                                    lastDate: DateTime(2100));
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: ww * 0.35,
                                            height: hh * 0.075,
                                            padding:
                                                EdgeInsets.only(top: ww * 0.02),
                                            child: DateTimeField(
                                              controller: _startTimeController,
                                              decoration: InputDecoration(
                                                errorText: _validate
                                                    ? validateEventInfo(
                                                        _eventTimeController
                                                            .text)
                                                    : null,
                                                hintText: 'Time',
                                                suffixIcon:
                                                    Icon(Icons.watch_later),
                                                hintStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontFamily: "nunito",
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035),
                                                filled: true,
                                                fillColor: Colors.white70,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: color1,
                                                      width: 0.5),
                                                ),
                                              ),
                                              format: format,
                                              onShowPicker: (context,
                                                  currentValue) async {
                                                final time =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                      TimeOfDay.fromDateTime(
                                                          currentValue ??
                                                              DateTime.now()),
                                                );
                                                return DateTimeField.convert(
                                                    time);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: ww * 0.02),
                                        child: Divider(height: 5),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: ww * 0.04),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "ENDS AT",
                                            style: TextStyle(
                                                fontFamily: "nunito",
                                                fontSize: ww * 0.03,
                                                color: Colors.blueGrey),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: ww * 0.35,
                                            height: hh * 0.075,
                                            padding:
                                                EdgeInsets.only(top: ww * 0.02),
                                            child: DateTimeField(
                                              format: dateFormat,
                                              controller: _stopDateController,
                                              decoration: InputDecoration(
                                                errorText: _validate
                                                    ? validateEventInfo(
                                                        _eventDateController
                                                            .text)
                                                    : null,
                                                hintText: 'Choose Date',
                                                suffixIcon:
                                                    Icon(Icons.calendar_today),
                                                hintStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontFamily: "nunito",
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035),
                                                filled: true,
                                                fillColor: Colors.white70,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: color1,
                                                      width: 0.5),
                                                ),
                                              ),
                                              onShowPicker:
                                                  (context, currentValue) {
                                                return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(1900),
                                                    initialDate: currentValue ??
                                                        DateTime.now(),
                                                    lastDate: DateTime(2100));
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: ww * 0.35,
                                            height: hh * 0.075,
                                            padding:
                                                EdgeInsets.only(top: ww * 0.02),
                                            child: DateTimeField(
                                              controller: _stopTimeController,
                                              decoration: InputDecoration(
                                                errorText: _validate
                                                    ? validateEventInfo(
                                                        _eventTimeController
                                                            .text)
                                                    : null,
                                                hintText: 'Time',
                                                suffixIcon:
                                                    Icon(Icons.watch_later),
                                                hintStyle: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontFamily: "nunito",
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035),
                                                filled: true,
                                                fillColor: Colors.white70,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  borderSide: BorderSide(
                                                      color: color1,
                                                      width: 0.5),
                                                ),
                                              ),
                                              format: format,
                                              onShowPicker: (context,
                                                  currentValue) async {
                                                final time =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                      TimeOfDay.fromDateTime(
                                                          currentValue ??
                                                              DateTime.now()),
                                                );
                                                return DateTimeField.convert(
                                                    time);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: ww * 0.02),
                                        child: Divider(height: 5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Padding(
                        padding: EdgeInsets.only(top: ww * 0.08),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "UPLOAD EVENT BANNER",
                                  style: TextStyle(
                                    fontFamily: "nunito",
                                    fontSize: ww * 0.040,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                _image == null
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          getImage();
                                        },
                                        child: DottedBorder(
                                            color: color1,
                                            strokeCap: StrokeCap.round,
                                            borderType: BorderType.RRect,
                                            dashPattern: [2, 4],
                                            radius: Radius.circular(4),
                                            strokeWidth: 1,
                                            child: Container(
                                                height: ww * 0.07,
                                                width: ww * 0.07,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[50],
                                                ),
                                                child: Center(
                                                    child: Icon(Icons.edit,
                                                        size: ww * 0.04,
                                                        color: Colors.grey)))),
                                      )
                              ],
                            ),
                            Container(
                              // child: buildGridView()
                              child: _image == null
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.only(top: ww * 0.01),
                                      height: ww * 0.45,
                                      width: ww * 0.90,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        child: Image.file(
                                          _image,
                                          width: ww * 0.25,
                                          height: ww * 0.20,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ww * 0.01),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  _image == null
                                      ? GestureDetector(
                                          onTap: () {
                                            getImage();
                                            // loadAssets();
                                          },
                                          child: DottedBorder(
                                            color: color1,
                                            strokeCap: StrokeCap.round,
                                            borderType: BorderType.RRect,
                                            dashPattern: [2, 4],
                                            radius: Radius.circular(12),
                                            strokeWidth: 1,
                                            child: Container(
                                                height: ww * 0.15,
                                                width: ww * 0.20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[50],
                                                ),
                                                child: Center(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(Icons.cloud_upload,
                                                            size: ww * 0.08,
                                                            color: color1),
                                                        Text(
                                                          "Upload",
                                                          style: TextStyle(
                                                              color: color1,
                                                              fontFamily:
                                                                  "nunito",
                                                              fontSize:
                                                                  ww * 0.026),
                                                        )
                                                      ]),
                                                )),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ww * 0.08),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "SUPPORTING EVENT PHOTOS",
                                    style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: ww * 0.03,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ww * 0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: ww * 0.83,
                                      height: hh * 0.135,
                                      child: buildGridView())
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: ww * 0.08),
                                child: Column(children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "PRICING",
                                        style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: ww * 0.03,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: ww * 0.27,
                                        height: hh * 0.075,
                                        padding:
                                            EdgeInsets.only(top: ww * 0.02),
                                        child: DropdownButton(
                                          hint: Text(
                                            'Choose Pricing',
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontFamily: "nunito",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035),
                                          ),
                                          // Not necessary for Option 1
                                          value: _selectedpricing,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedpricing = newValue;
                                            });
                                            if (newValue == "PAID") {
                                              setState(() {
                                                chosenPaid = true;
                                              });
                                            } else {
                                              setState(() {
                                                chosenPaid = false;
                                              });
                                            }
                                          },
                                          items: _pricing.map((price) {
                                            return DropdownMenuItem(
                                              child: new Text(price,
                                                  style: TextStyle(
                                                      fontFamily: "nunito")),
                                              value: price,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      chosenPaid
                                          ? GestureDetector(
                                              onTap: () async {
                                                List<PricingEntry> persons =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SOF2(),
                                                  ),
                                                );
                                                if (persons != null)
                                                  persons.forEach(print);
                                              },
                                              child: Container(
                                                  width: ww * 0.32,
                                                  height: hh * 0.045,
                                                  padding: EdgeInsets.only(
                                                      top: ww * 0.02),
                                                  decoration: BoxDecoration(
                                                      color: color1,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 6.0,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 5.0)
                                                      ]),
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: ww * 0.012),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text("ADD PRICING",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      "nunito",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: ww *
                                                                      0.030)),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ])),
                            Column(
                              children: <Widget>[
                                // Column(
                                //     children: <Widget>[
                                //       Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //         children: <Widget>[
                                //           Container(
                                //             width: ww * 0.35,
                                //             height: hh * 0.075,
                                //             padding: EdgeInsets.only(
                                //                 top: ww * 0.02),
                                //             child: TextFormField(
                                //               controller:
                                //                   _ticketTypeController,
                                //               decoration: InputDecoration(
                                //                 errorText: _validate
                                //                     ? validateEventInfo(
                                //                         _ticketTypeController
                                //                             .text)
                                //                     : null,
                                //                 hintText: 'Type',
                                //                 suffixIcon: Icon(
                                //                     Icons.calendar_today),
                                //                 hintStyle: TextStyle(
                                //                     color: Colors.blueGrey,
                                //                     fontFamily: "nunito",
                                //                     fontSize:
                                //                         MediaQuery.of(context)
                                //                                 .size
                                //                                 .width *
                                //                             0.035),
                                //                 filled: true,
                                //                 fillColor: Colors.white70,
                                //                 enabledBorder:
                                //                     OutlineInputBorder(
                                //                   borderRadius:
                                //                       BorderRadius.all(
                                //                           Radius.circular(
                                //                               8.0)),
                                //                   borderSide: BorderSide(
                                //                       color: Colors.grey,
                                //                       width: 0.5),
                                //                 ),
                                //                 focusedBorder:
                                //                     OutlineInputBorder(
                                //                   borderRadius:
                                //                       BorderRadius.all(
                                //                           Radius.circular(
                                //                               8.0)),
                                //                   borderSide: BorderSide(
                                //                       color: color1,
                                //                       width: 0.5),
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //           Container(
                                //             width: ww * 0.35,
                                //             height: hh * 0.075,
                                //             padding: EdgeInsets.only(
                                //                 top: ww * 0.02),
                                //             child: TextFormField(
                                //               controller:
                                //                   _ticketAmountController,
                                //               keyboardType:
                                //                   TextInputType.number,
                                //               inputFormatters: <
                                //                   TextInputFormatter>[
                                //                 WhitelistingTextInputFormatter
                                //                     .digitsOnly
                                //               ],
                                //               decoration: InputDecoration(
                                //                 errorText: _validate
                                //                     ? validateEventInfo(
                                //                         _ticketAmountController
                                //                             .text)
                                //                     : null,
                                //                 hintText: 'Amount',
                                //                 suffixIcon:
                                //                     Icon(Icons.attach_money),
                                //                 hintStyle: TextStyle(
                                //                     color: Colors.blueGrey,
                                //                     fontFamily: "nunito",
                                //                     fontSize:
                                //                         MediaQuery.of(context)
                                //                                 .size
                                //                                 .width *
                                //                             0.035),
                                //                 filled: true,
                                //                 fillColor: Colors.white70,
                                //                 enabledBorder:
                                //                     OutlineInputBorder(
                                //                   borderRadius:
                                //                       BorderRadius.all(
                                //                           Radius.circular(
                                //                               8.0)),
                                //                   borderSide: BorderSide(
                                //                       color: Colors.grey,
                                //                       width: 0.5),
                                //                 ),
                                //                 focusedBorder:
                                //                     OutlineInputBorder(
                                //                   borderRadius:
                                //                       BorderRadius.all(
                                //                           Radius.circular(
                                //                               8.0)),
                                //                   borderSide: BorderSide(
                                //                       color: color1,
                                //                       width: 0.5),
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       // Padding(
                                //       //   padding:
                                //       //       EdgeInsets.only(top: ww * 0.01),
                                //       //   child: Row(
                                //       //     mainAxisAlignment:
                                //       //         MainAxisAlignment.start,
                                //       //     children: <Widget>[
                                //       //       Row(
                                //       //         mainAxisAlignment:
                                //       //             MainAxisAlignment.start,
                                //       //         children: <Widget>[
                                //       //           Text(
                                //       //             "+ Add More Ticket Types",
                                //       //             style: TextStyle(
                                //       //                 fontFamily: "nunito",
                                //       //                 fontSize: ww * 0.035,
                                //       //                 color: color1,
                                //       //                 fontWeight:
                                //       //                     FontWeight.bold),
                                //       //           ),
                                //       //         ],
                                //       //       )
                                //       //     ],
                                //       //   ),
                                //       // )
                                //     ],
                                //   )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ww * 0.03),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _createEvent(_image);
                    },
                    child: Container(
                        width: ww * 0.90,
                        height: hh * 0.055,
                        padding: EdgeInsets.only(top: ww * 0.02),
                        decoration: BoxDecoration(
                            color: color1,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 6.0,
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5.0)
                            ]),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: ww * 0.015),
                            child: Column(
                              children: <Widget>[
                                Text("Create Event",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "nunito",
                                        fontWeight: FontWeight.bold,
                                        fontSize: ww * 0.040)),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(height: ww * 0.05),
              ],
            ),
          )),
    );
  }
}

class SOF extends StatefulWidget {
  @override
  _SOFState createState() => _SOFState();
}

class _SOFState extends State<SOF> {
  Future<bool> setSessionstoPreference(String sessions) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageSessions, sessions);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey1.currentState.showSnackBar(new SnackBar(
        content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Raleway",
        fontSize: 13,
      ),
    )));
  }

  final dateFormat = DateFormat("yyyy-MM-dd");
  final format = DateFormat("HH:mm");

  var color1 = Color.fromRGBO(92, 72, 213, 0.8);

  // var nameTECs = <TextEditingController>[];
  // var ageTECs = <TextEditingController>[];
  // var jobTECs = <TextEditingController>[];

  // session entries
  var startTimeTECs = <TextEditingController>[];
  var startDayTECs = <TextEditingController>[];
  var endTimeTECs = <TextEditingController>[];
  var endDayTECs = <TextEditingController>[];

  var cards = <Card>[];

  Card createCard() {
    var startDateController = TextEditingController();
    var startTimeController = TextEditingController();
    var endDateController = TextEditingController();
    var endTimeController = TextEditingController();

    startTimeTECs.add(startTimeController);
    startDayTECs.add(startDateController);
    endTimeTECs.add(endTimeController);
    endDayTECs.add(endDateController);

    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var jobController = TextEditingController();

    // nameTECs.add(nameController);
    // ageTECs.add(ageController);
    // jobTECs.add(jobController);

    return Card(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'SESSION ${cards.length + 1}',
              style: TextStyle(
                  fontFamily: "nunito", fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "STARTS AT",
                          style: TextStyle(
                              fontFamily: "nunito",
                              fontSize: 12,
                              color: Colors.blueGrey),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 140,
                          height: 80,
                          padding: EdgeInsets.only(top: 8),
                          child: DateTimeField(
                            format: dateFormat,
                            controller: startDateController,
                            decoration: InputDecoration(
                              hintText: 'Choose Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontFamily: "nunito",
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: color1, width: 0.5),
                              ),
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                          ),
                        ),
                        Container(
                          width: 140,
                          height: 80,
                          padding: EdgeInsets.only(top: 8),
                          child: DateTimeField(
                            controller: startTimeController,
                            decoration: InputDecoration(
                              hintText: 'Time',
                              suffixIcon: Icon(Icons.watch_later),
                              hintStyle: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: "nunito",
                                  fontSize: 13),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: color1, width: 0.5),
                              ),
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Divider(height: 5),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "ENDS AT",
                          style: TextStyle(
                              fontFamily: "nunito",
                              fontSize: 12,
                              color: Colors.blueGrey),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 140,
                          height: 80,
                          padding: EdgeInsets.only(top: 8),
                          child: DateTimeField(
                            format: dateFormat,
                            controller: endDateController,
                            decoration: InputDecoration(
                              hintText: 'Choose Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              hintStyle: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: "nunito",
                                  fontSize: 13),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: color1, width: 0.5),
                              ),
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                          ),
                        ),
                        Container(
                          width: 140,
                          height: 80,
                          padding: EdgeInsets.only(top: 8),
                          child: DateTimeField(
                            controller: endTimeController,
                            decoration: InputDecoration(
                              hintText: 'Time',
                              suffixIcon: Icon(Icons.watch_later),
                              hintStyle: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: "nunito",
                                  fontSize: 13),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: color1, width: 0.5),
                              ),
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                  ],
                ),
              ),
            ],
          )
          // TextField(
          //     controller: nameController,
          //     decoration: InputDecoration(labelText: 'Full Name')),
          // TextField(
          //     controller: ageController,
          //     decoration: InputDecoration(labelText: 'Age')),
          // TextField(
          //     controller: jobController,
          //     decoration: InputDecoration(labelText: 'Study/ job')),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cards.add(createCard());
  }

  @override
  Widget build(BuildContext context) {
    _onDone() {
      List<SessionEntry> entries = [];
      for (int i = 0; i < cards.length; i++) {
        var id = i;
        var startdate = startDayTECs[i].text;
        var starttime = startTimeTECs[i].text;
        var enddate = endDayTECs[i].text;
        var endtime = endTimeTECs[i].text;
        entries.add(SessionEntry(id, startdate, starttime, enddate, endtime));
      }
      print(entries);
      print(entries.length);
      showInSnackBar("Successfully Uploaded");
      if (entries.length != 0) {
        setSessionstoPreference(entries.toString());
      }
      Navigator.pop(context);

      /* List<PersonEntry> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = nameTECs[i].text;
      var age = ageTECs[i].text;
      var job = jobTECs[i].text;
      entries.add(PersonEntry(name, age, job));
    }
    print(entries); */
      /* Navigator.pop(context, entries); */
    }

    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;
    var color1 = Color.fromRGBO(92, 72, 213, 0.8);
    return Scaffold(
      key: _scaffoldKey1,
      appBar: AppBar(
        backgroundColor: color1,
        centerTitle: true,
        title: Text(
          "ADD SESSIONS",
          style: TextStyle(
            fontFamily: "nunito",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return cards[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => setState(() => cards.add(createCard())),
              child: Container(
                  width: ww * 0.32,
                  height: hh * 0.045,
                  padding: EdgeInsets.only(top: ww * 0.02),
                  decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 6.0,
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5.0)
                      ]),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: ww * 0.012),
                      child: Column(
                        children: <Widget>[
                          Text("ADD NEW",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "nunito",
                                  fontWeight: FontWeight.bold,
                                  fontSize: ww * 0.030)),
                        ],
                      ),
                    ),
                  )),
            ),
            // child: RaisedButton(
            //   child: Text('add new'),
            //   onPressed: () => setState(() => cards.add(createCard())),
            // ),
          )
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}

// class PersonEntry {
//   final String name;
//   final String age;
//   final String studyJob;

//   PersonEntry(this.name, this.age, this.studyJob);
//   @override
//   String toString() {
//     return 'Person: name= $name, age= $age, study job= $studyJob';
//   }
// }

class SessionEntry {
  final int id;
  final String startdate;
  final String starttime;
  final String enddate;
  final String endtime;
  SessionEntry(
      this.id, this.startdate, this.starttime, this.enddate, this.endtime);
  @override
  String toString() {
    return '{"start_date":"$startdate","start_time":"$starttime","end_date":"$enddate","end_time":"$endtime"}';
  }
}

class SOF2 extends StatefulWidget {
  @override
  _SOF2State createState() => _SOF2State();
}

class _SOF2State extends State<SOF2> {
  Future<bool> _setPricingtoPreference(String pricing) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storagePricing, pricing);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

  var color1 = Color.fromRGBO(92, 72, 213, 0.8);

  // var nameTECs = <TextEditingController>[];
  // var ageTECs = <TextEditingController>[];
  // var jobTECs = <TextEditingController>[];

  // session entries
  var pricingTypeTECs = <TextEditingController>[];
  var pricingAmountTECs = <TextEditingController>[];

  var cards = <Card>[];

  Card createCard() {
    var pricingTypeController = TextEditingController();
    var pricingAmountController = TextEditingController();

    pricingTypeTECs.add(pricingTypeController);
    pricingAmountTECs.add(pricingAmountController);

    return Card(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'PRICING ${cards.length + 1}',
              style: TextStyle(
                  fontFamily: "nunito", fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 140,
                      height: 80,
                      padding: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        controller: pricingTypeController,
                        decoration: InputDecoration(
                          // errorText: _validate
                          //     ? validateEventInfo(
                          //         _ticketTypeController
                          //             .text)
                          //     : null,
                          hintText: 'Type',
                          suffixIcon: Icon(Icons.calendar_today),
                          hintStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: "nunito",
                              fontSize: 14),
                          filled: true,
                          fillColor: Colors.white70,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: color1, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 80,
                      padding: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        controller: pricingAmountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          // errorText: _validate
                          //     ? validateEventInfo(
                          //         _ticketAmountController
                          //             .text)
                          //     : null,
                          hintText: 'Amount',
                          suffixIcon: Icon(Icons.attach_money),
                          hintStyle: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: "nunito",
                              fontSize: 14),
                          filled: true,
                          fillColor: Colors.white70,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: color1, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
          // TextField(
          //     controller: nameController,
          //     decoration: InputDecoration(labelText: 'Full Name')),
          // TextField(
          //     controller: ageController,
          //     decoration: InputDecoration(labelText: 'Age')),
          // TextField(
          //     controller: jobController,
          //     decoration: InputDecoration(labelText: 'Study/ job')),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    cards.add(createCard());
  }

  @override
  Widget build(BuildContext context) {
    _onDone() {
      List<PricingEntry> entries = [];
      for (int i = 0; i < cards.length; i++) {
        var type = pricingTypeTECs[i].text;
        var amount = pricingAmountTECs[i].text;

        entries.add(PricingEntry(type, amount));
      }
      print(entries);
      print(entries.length);
      // showInSnackBar("Successfully Uploaded");
      if (entries.length != 0) {
        _setPricingtoPreference(entries.toString());
      }
      Navigator.pop(context);

      /* List<PersonEntry> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = nameTECs[i].text;
      var age = ageTECs[i].text;
      var job = jobTECs[i].text;
      entries.add(PersonEntry(name, age, job));
    }
    print(entries); */
      /* Navigator.pop(context, entries); */
    }

    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;
    var color1 = Color.fromRGBO(92, 72, 213, 0.8);
    return Scaffold(
      key: _scaffoldKey2,
      appBar: AppBar(
        backgroundColor: color1,
        centerTitle: true,
        title: Text(
          "ADD PRICING",
          style: TextStyle(
            fontFamily: "nunito",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return cards[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => setState(() => cards.add(createCard())),
              child: Container(
                  width: ww * 0.32,
                  height: hh * 0.045,
                  padding: EdgeInsets.only(top: ww * 0.02),
                  decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 6.0,
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5.0)
                      ]),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: ww * 0.012),
                      child: Column(
                        children: <Widget>[
                          Text("ADD NEW",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "nunito",
                                  fontWeight: FontWeight.bold,
                                  fontSize: ww * 0.030)),
                        ],
                      ),
                    ),
                  )),
            ),
            // child: RaisedButton(
            //   child: Text('add new'),
            //   onPressed: () => setState(() => cards.add(createCard())),
            // ),
          )
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}

class PricingEntry {
  final String type;
  final String amount;

  PricingEntry(this.type, this.amount);
  @override
  String toString() {
    return '{"name":"$type","amount":"$amount"}';
  }
}
