import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkt/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import '../../utils.dart';

String kiv = "";
String ksp = "";
String keycode = "";
String errMess = "";

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class VerifyTicket extends StatefulWidget {
  final String phone;
  const VerifyTicket(this.phone);
  @override
  _VerifyTicketState createState() => _VerifyTicketState();
}

class _VerifyTicketState extends State<VerifyTicket> {
  File _imageFile;
  ui.Image _image;
  bool isLoading = false;

  Future getValue() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      keycode = prefs.getString('keycode');
      kiv = prefs.getString('kiv');
      ksp = prefs.getString('ksp');
    });
    print(kiv);
  }

  _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      isLoading = true;
    });

    if (mounted) {
      setState(() {
        _imageFile = File(imageFile.path);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ww = MediaQuery.of(context).size.width;
    var hh = MediaQuery.of(context).size.height;

    _uploadImage(File imageFile) async {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse("$baseUrl/tickets/verify");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('photo', stream, length,
          filename: basename(imageFile.path));
      request.headers["kiv"] = kiv;
      request.headers["ksp"] = ksp;
      request.headers["keyCode"] = keycode;
      request.fields["phone"] = widget.phone;
      request.fields["event_id"] = "2351ec12-7dda-429c-ae82-7cec43eae17f";

      //contentType: new MediaType('image', 'png'));
      // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request

      request.files.add(multipartFile);

      var response = await request.send();
      print(response.statusCode);

      try {
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);

          if (response.statusCode == 200) {
            showMessage(context, json.decode(value)["data"], "Message");
          } else {
            showMessage(context, json.decode(value)["data"], "OOPS ... ");
            setState(() {
              errMess = json.decode(value)["data"];
            });
          }
        });
      } catch (e) {
        // pr.hide();

      }

      print("status is ${response.statusCode}");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        title: Text(
          "Verify",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: _imageFile == null
            ? Text('No image selected.')
            : Image.file(_imageFile),
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
