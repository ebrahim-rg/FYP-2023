import 'package:flutter/material.dart';
import 'package:fyp/allrides_screen.dart';
import 'package:fyp/route_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'signin_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: FutureBuilder(
          future: Future.wait([_getAuthState(), _getUserId(), _getToken()]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<dynamic> data = snapshot.data!;
              final bool isSignedIn = data[0];
              print(isSignedIn);
              final String userid = data[1];
              print(userid);
              final String token = data[2];
              print(token);
              return isSignedIn
                  ? MyHomePage(
                      title: "Home",
                      token: token,
                      userid: userid,
                    )
                  :LoginPage();
              // } else {
              //   return SplashScreen();
              // }
            } else {
              return CircularProgressIndicator(color:Colors.yellow);
            }
          }),
    );
  }

  Future<bool> _getAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSignedIn') ?? false;
  }

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
