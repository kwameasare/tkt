import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:path/path.dart';
import 'package:tkt/Screens/home.dart';

import '../../constants.dart';
import '../../utils.dart';

String _kiv = "";
String _ksp = "";
String _keycode = "";

String errMess = "";

ProgressDialog pr;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class BuyTicket extends StatefulWidget {
  final String id;
  const BuyTicket(this.id);

  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
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

  final picker = ImagePicker();

  _getImageAndDetectFaces() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    // final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(File(pickedFile.path));
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _faces = faces;
        _loadImage(File(pickedFile.path));
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
      _keycode = prefs.getString('keycode');
      _kiv = prefs.getString('kiv');
      _ksp = prefs.getString('ksp');
    });
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
      final SharedPreferences prefs = await _prefs;
      var phone = prefs.getString('phoneNumber');
      var uri = Uri.parse("$baseUrl/tickets");
      print("233$phone");
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(imageFile.path));
      request.headers["kiv"] = _kiv;
      request.headers["ksp"] = _ksp;
      request.headers["keyCode"] = _keycode;
      request.fields["phone"] = "233$phone";
      request.fields["ticket_type_id"] = widget.id;
      request.fields["status"] = "ACTIVE";
      request.files.add(multipartFile);

      var response = await request.send();
      print(response.statusCode);

      try {
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
          pr.hide();
          if (response.statusCode == 200) {
            showMessage(
                context, json.decode(value)["message"], "Congratulations");
            Future.delayed(Duration(seconds: 2), () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            });
          } else {
            pr.hide();

            showMessage(context, json.decode(value)["message"], "OOPS ... ");
            setState(() {
              errMess = json.decode(value)["message"];
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
          "Upload Picture",
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
              ? Center(child: Text('No Facial Recognition Image Selected.'))
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
