import 'package:flutter/material.dart';
import 'package:flutter_blog/AddPost.dart';
import 'package:flutter_blog/Android.dart';
import 'dart:convert' as convert;
import 'package:flutter_blog/Flutter.dart';
import 'package:flutter_blog/Kotlin.dart';

class Posts extends StatefulWidget {

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> with SingleTickerProviderStateMixin {

  String uName;
  String uPassword;
  TabController tabController;
  int currentIndex;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(vsync: this, length: 3);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        bottom: TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(text: "Flutter"),
            Tab(text: "Android"),
            Tab(text: "Kotlin"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          Flutter(),
          Android(),
          Kotlin(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

          currentIndex = tabController.index;
          print("AAAAAAAAAAAAAAa"+currentIndex.toString());

          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return AddPost(currentIndex);
          }));
        },
      ),
    );
  }
}
