// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  //Yellowish color
  final Color _primaryColor = const Color(0xFFFFFFFF);
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
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
                      setState(() => show = true);
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
  final String text;
  SecondRoute({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nurse for " + text.toUpperCase()),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(text),
        ),
      ),
    );
  }
}

Future<http.Response> fetchAlbum() {
  return http.get('https://jsonplaceholder.typicode.com/albums/1');
}