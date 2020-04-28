// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Nurse> fetchNurse(String postcode) async {
  print(postcode);
  final response =
      await http.get('http://findmynurse.co.uk/api/' + postcode);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("Fetched Data success");
    return Nurse.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load NUrse');
  }
}

class Nurse {
  final String name;
  final String postCode;
  final String email;

  Nurse({this.name, this.postCode, this.email});

  factory Nurse.fromJson(Map<String, dynamic> json) {
    return Nurse(
      name: json['firstName'],
      postCode: json['postCode'],
      email: json['email'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find My nurse',
      home: Scaffold(
        body: Search(),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool show = true;
  final Color _primaryColor = const Color(0xFFFFFFFF);
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        width: show ? 50 : 300,
        height: 50,
        child: GestureDetector(
          onTap: () {
            setState(() => show = false);
          },
          child: show
              ? Icon(
                  Icons.search,
                  color: Color(0xFFFFFFFF),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: myController,
                    cursorColor: _primaryColor,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 8.0),
                        border: InputBorder.none),
                    style: TextStyle(color: _primaryColor),
                    onSubmitted: (onSubmit) {

                      setState(() => show = true,);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondRoute(text: myController.text)),
                      );
                    },
                  ),
                ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: _primaryColor,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  String text;
  Future<Nurse> futureNurse;
  SecondRoute({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    futureNurse = fetchNurse(text);
    return MaterialApp(
      title: 'Nurse for' + text,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nurse For ' + text),
        ),
        body: Center(
          child: new Column ( 
            children: <Widget>[

              RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Go Back"),
        ),

            FutureBuilder<Nurse>(
            future: futureNurse,
            builder: (context, snapshot) {
              List<Widget> children;

        if (snapshot.hasData) {
          children = <Widget>[
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: new Column(
                
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 140.0)),
                  new Text("Name: " + snapshot.data.name),
                  new Padding(padding: EdgeInsets.only(top: 50.0)),
                  new Text("Email: " + snapshot.data.email),
                  new Padding(padding: EdgeInsets.only(top: 50.0)),
                  new Text("Postal Code: " + snapshot.data.postCode),

                ],
              ),
            )
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
            },
          ),
            ]
          )
        ),
      ),
    );
  }
}//Class
