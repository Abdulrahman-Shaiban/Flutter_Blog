import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blog/AppServer.dart';
import 'package:flutter_blog/Posts.dart';
import 'package:http/http.dart' as http;
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:image_picker/image_picker.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String imageB64, userEmail, userPassword;
  GlobalKey<FormState> login = new GlobalKey();
  File pickedimage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Form(
          key: login,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              CircularProfileAvatar(
                '',
                child: checkImage(),
                borderColor: Colors.blueAccent[100],
                borderWidth: 1,
                elevation: 2,
                radius: 50,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    color: Colors.blueAccent[100],
                    iconSize: 40,
                    onPressed: () async {
                      pickedimage = await ImagePicker.pickImage(
                          source: ImageSource.camera);

                      setState(() {});

                      List<int> imageBytes = pickedimage.readAsBytesSync();
                      imageB64 = base64Encode(imageBytes);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.photo),
                    color: Colors.blueAccent[100],
                    iconSize: 40,
                    onPressed: () async {
                      pickedimage = await ImagePicker.pickImage(
                          source: ImageSource.gallery);

                      setState(() {});

                      List<int> imageBytes = pickedimage.readAsBytesSync();
                      imageB64 = base64Encode(imageBytes);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 70,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Email",
                  hintText: "Enter Your Email",
                ),
                validator: (email) =>
                    email.isEmpty ? "Email is Required" : null,
                onSaved: (email) => userEmail = email,
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Password",
                  hintText: "Enter Your Password",
                ),
                validator: (password) =>
                    password.isEmpty ? "Password is Required" : null,
                onSaved: (password) => userPassword = password,
              ),
              SizedBox(
                height: 90,
              ),
              FlatButton(
                child: Text("Register"),
                color: Colors.blueAccent[100],
                padding: EdgeInsets.all(20),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  if (login.currentState.validate()) {
                    login.currentState.save();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Registering..."),
                            content: Icon(Icons.refresh),
                          );
                        });
                    addUser().then((data) {
                      if (!data.body.isEmpty) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (ctx) {
//                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                          return Posts();
                        }));
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkImage() {
    if (pickedimage == null)
      return Image.asset("images/mountains.jpg");

    return Image.file(pickedimage);
  }

  Future<http.Response> addUser() {
    return http.post(AppServer.SIGNUP_IP,
        body: {"image": imageB64,"username": userEmail, "password": userPassword});
  }

}
