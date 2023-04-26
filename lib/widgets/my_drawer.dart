import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fyp/daysettings_screen.dart';
import 'package:fyp/editprofile_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../signin_screen.dart';
import 'drawer_item.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer(
      {required this.token,
      required this.username,
      required this.userid,
      super.key});
  String token;
  String username;
  String userid;
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLoading = false;

  void _signOut(String bearerToken) async {
    setState(() {
      isLoading = true;
    });

    Response? response; // Define response object outside try block

    try {
      response = await post(
        Uri.parse('https://routify.cyclic.app/api/signout'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      String msg = '';
      Map<String, dynamic> data = jsonDecode(response.body);
      msg = data['message'];
      if (msg == "signout successful") {
        print(msg);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        msg = data['message'];
        print("signout unsuccessfull");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );
      }
    } catch (e) {
      print('exception caught: $e');
      if (response != null) {
        print('response body: ${response.body}');
      }
    }
  }

  void clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body:
                Center(child: CircularProgressIndicator(color: Colors.yellow)),
          )
        : Card();
  }
}
