import 'package:flutter/material.dart';
import 'package:flutter_blog/AppServer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'Comments.dart';

class Android extends StatefulWidget {
  @override
  _AndroidState createState() => _AndroidState();
}

class _AndroidState extends State<Android> {
  int pId;
  String pUser, pType, pData, pQuestion, pImage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFlutterPosts(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<dynamic> data = convert.jsonDecode(snapshot.data.body);

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (ctx, index) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
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
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(data[index]["question"]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 200,
                              width: 400,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network(
                                    AppServer.IP + data[index]["image"]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.thumb_up),
                                  color: Colors.blueAccent[100],
                                  iconSize: 40,
                                  onPressed: () async {},
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                IconButton(
                                  icon: Icon(Icons.thumb_down),
                                  color: Colors.blueAccent[100],
                                  iconSize: 40,
                                  onPressed: () async {},
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: ButtonTheme(
                                minWidth: 400,
                                height: 50,
                                child: FlatButton(
                                  child: Text("Comments"),
                                  color: Colors.grey[200],
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      child: Comments(data[index]["id"]),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
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
    );
  }

  Future<http.Response> getFlutterPosts() {
    return http.post(AppServer.ANDROID_IP);
  }
}
