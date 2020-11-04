import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/Screens/home.dart';

import '../constants.dart';
import '../utils.dart';

String kiv = "";
String ksp = "";
String keycode = "";

String errMess = "";

ProgressDialog pr;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class MlPage extends StatefulWidget {
  final String full_name;
  final String email;
  final String phone;

  const MlPage(this.full_name, this.email, this.phone);
  @override
  _MlPageState createState() => _MlPageState();
}

class _MlPageState extends State<MlPage> {
  final GlobalKey<ScaffoldState> scafkey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    scafkey.currentState.showSnackBar(new SnackBar(
        content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Raleway",
        fontSize: 13,
      ),
    )));
  }

  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;

  _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
        _loadImage(imageFile);
      });

      print(faces);
    }
  }

  // _uploadFile() async {
  //   FormData formData = new FormData.from({
  //     "name" : widget.full_name,
  //     "email" : widget.email,
  //     "photo" : new
  //   });
  // }

  _upload(File file) async {
    print("sending to server");
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';

    dio
        .post("$baseUrl/auth/register", data: data)
        .then((response) => print(response))
        .catchError((error) => print(error));
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
        isLoading = false;
      }),
    );
  }

  Future getValue() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      keycode = prefs.getString('keycode');
      kiv = prefs.getString('kiv');
      ksp = prefs.getString('ksp');
    });
    print(kiv);
  }

  @override
  void initState() {
    getValue();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(message: 'Showing some progress...');

    //Optional
    pr.style(
      message: 'Please wait..',
      borderRadius: 4.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(strokeWidth: 2.0),
      elevation: 5.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 8, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600),
    );

    _uploadImage(File imageFile) async {
      pr.show();

      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse("$baseUrl/auth/register");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(imageFile.path));
      request.headers["kiv"] = kiv;
      request.headers["ksp"] = ksp;
      request.headers["keyCode"] = keycode;
      request.fields["phoneNum"] = widget.phone;

      request.fields["user_type"] = "PERSONAL";

      request.fields["countryCode"] = "gh";

      //contentType: new MediaType('image', 'png'));
      // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
      request.fields["name"] = widget.full_name;
      request.fields["email"] = widget.email;
      request.files.add(multipartFile);

      var response = await request.send();
      print(response.statusCode);

      try {
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
          pr.hide();
          if (response.statusCode == 200) {
            setNumber(widget.phone.substring(widget.phone.length - 9));
            showMessage(context, "You have successfully registered..",
                "Congratulations");
            Future.delayed(Duration(seconds: 2), () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            });
          } else {
            pr.hide();

            showMessage(context, json.decode(value)["data"], "OOPS ... ");
            setState(() {
              errMess = json.decode(value)["data"];
            });
          }
        });
      } catch (e) {
        pr.hide();
      }

      print("status is ${response.statusCode}");
    }

    return Scaffold(
      key: scafkey,
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: color1,
        title: Text(
          "Upload Profile Picture",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: InkWell(
                onTap: () {
                  _getImageAndDetectFaces();
                },
                child: Icon(Icons.edit),
              )
              // onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
              // },
              // child: receivedmail ? Icon(Icons.drafts) : Icon(Icons.mail)),
              )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (_imageFile == null)
              ? Center(child: Text('No image selected'))
              : Center(
                  child: FittedBox(
                    child: SizedBox(
                      width: _image.width.toDouble(),
                      height: _image.height.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(_image, _faces),
                      ),
                    ),
                  ),
                ),
      floatingActionButton: isLoading
          ? Text("")
          : (_imageFile == null)
              ? FloatingActionButton(
                  backgroundColor: color1,
                  onPressed: _getImageAndDetectFaces,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                )
              : FloatingActionButton.extended(
                  backgroundColor: color1,
                  onPressed: () => _uploadImage(_imageFile),
                  icon: Icon(Icons.save),
                  label: Text("Continue"),
                ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.yellow;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
