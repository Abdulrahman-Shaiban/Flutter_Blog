import 'package:flutter/material.dart';
import 'package:flutter_blog/AppServer.dart';
import 'package:flutter_blog/SignUp.dart';
import 'package:flutter_blog/Posts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Login extends StatefulWidget {

  static String uName;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String userEmail, userPassword;
  GlobalKey<FormState> login = new GlobalKey();

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
                Icon(
                  Icons.lock,
                  color: Colors.blueAccent[100],
                  size: 100.0,
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
                  height: 70,
                ),
                FlatButton(
                  child: Text("Login"),
                  color: Colors.blueAccent[100],
                  padding: EdgeInsets.all(17),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    onPressed: () {
                      if (login.currentState.validate()) {
                        login.currentState.save();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Logging in"),
                                content: Icon(Icons.refresh),
                              );
                            });
                        checkUser().then((data) {

                          Map<String,dynamic> getData = convert.jsonDecode(data.body);
                          Login.uName = getData["u_name"];
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (ctx) {
//                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                  return Posts();
                                }));

                        });
                      }
                    },
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  child: Text("Sign Up"),
                  color: Colors.blueAccent[100],
                  padding: EdgeInsets.all(17),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (ctx) {
                          return Register();
                        }));
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }

  Future<http.Response> checkUser() {
    return http.post(AppServer.LOGIN_IP,
        body: {"username": userEmail, "password": userPassword});
  }
}
