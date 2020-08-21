import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blog/AppServer.dart';
import 'package:flutter_blog/Login.dart';
import 'package:flutter_blog/Posts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class AddPost extends StatefulWidget {

  int currentIndex;
  AddPost(this.currentIndex);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  String postTitle, imageB64;
  GlobalKey<FormState> add = new GlobalKey();
  File pickedimage;
  String type;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.currentIndex == 0) {
      type = "flutter";
    } else if(widget.currentIndex == 1) {
      type = "android";
    } else if(widget.currentIndex == 2) {
      type = "kotlin";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Form(
          key: add,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Post Title",
                  hintText: "Enter Your Post Title",
                ),
                validator: (title) =>
                    title.isEmpty ? "Post Title is Required" : null,
                onSaved: (title) => postTitle = title,
              ),
              SizedBox(
                height: 70,
              ),
              Container(
                height: 200,
                width: 200,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: checkImage(),
                ),
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
              FlatButton(
                child: Text("Add"),
                color: Colors.blueAccent[100],
                padding: EdgeInsets.all(17),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                onPressed: () {
                  if (add.currentState.validate()) {
                    add.currentState.save();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Adding Post"),
                            content: Icon(Icons.refresh),
                          );
                        });
                    addPost().then((data) {
                      if(!data.body.isEmpty) {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (ctx) {
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
    if (pickedimage == null) return Image.asset("images/mountains.jpg");

    return Image.file(pickedimage);
  }

  Future<http.Response> addPost() {
    return http.post(AppServer.ADD_POST_IP, body: {
      "name": Login.uName,
      "image": imageB64,
      "question": postTitle,
      "action": "0",
      "type": type,
      "date": DateFormat.yMd().add_jm().format(new DateTime.now()).toString(),
    });
  }
}
