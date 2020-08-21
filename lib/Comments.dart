import 'package:flutter/material.dart';
import 'package:flutter_blog/AppServer.dart';
import 'package:flutter_blog/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_blog/CustomDailog.dart' as customDialog;

import 'package:intl/intl.dart';

class Comments extends StatefulWidget {
  var pId;

  Comments(this.pId);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  var id;
  String userComment;
  GlobalKey<FormState> add = new GlobalKey();
  var _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.pId;
  }

  @override
  Widget build(BuildContext context) {
    return customDialog.AlertDialog(
      title: Text("Comments"),
      content: Container(
        height: 600,
        width: 200,
        child: FutureBuilder(
          future: getComments(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<dynamic> data = convert.jsonDecode(snapshot.data.body);

                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.account_circle,
                              size: 60,
                            ),
                            title: Text(data[index]["user"]),
                            subtitle: Text(data[index]["date"]),
                            trailing: InkWell(
                              child: Icon(Icons.more_horiz),
                              onTap: () {},
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Text(data[index]["answer"]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                        ],
                      ));
                    });
              } else {
                return Center(
                  child: Text("No Data Found"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      actions: <Widget>[
        Form(
          key: add,
          child: Row(
            children: <Widget>[
              Container(
                width: 230,
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Comment",
                    hintText: "Enter Your Comment",
                  ),
                  validator: (comment) =>
                      comment.isEmpty ? "Comment is Required" : null,
                  onSaved: (comment) => userComment = comment,
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Container(
                width: 70,
                child: FlatButton(
                  child: Text("add"),
                  textColor: Colors.white,
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
                              title: Text("Adding Comment"),
                              content: Icon(Icons.refresh),
                            );
                          });
                      addComment().then((data) {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        _controller.clear();
                        setState(() {});
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<http.Response> getComments() {
    return http.post(AppServer.Comments_IP, body: {"pid": id});
  }

  Future<http.Response> addComment() {
    return http.post(AppServer.ADD_Comments_IP, body: {
      "name": Login.uName,
      "content": userComment,
      "pid": id,
      "date": DateFormat.yMd().add_jm().format(new DateTime.now()).toString(),
    });
  }
}
