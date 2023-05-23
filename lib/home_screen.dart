import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/allrides_screen.dart';
import 'package:fyp/editprofile_screen.dart';
import 'package:fyp/route_screen.dart';
import 'package:fyp/widgets/daycircle.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'daysettings_screen.dart';
import 'signin_screen.dart';
import 'widgets/drawer_item.dart';
import 'widgets/my_drawer.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.token, required this.title, required this.userid})
      : super();

  final String title;
  String userid;
  String token;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String>? _username;
  bool isLoading = false;
  bool isMonday = false;
  bool isTuesday = false;
  bool isWednesday = false;
  bool isThursday = false;
  bool isFriday = false;
  bool isSaturday = false;

  Future<void> _getCurrentLocation() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Check location permission status
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // Get the current position
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Post the location data to the API endpoint
    final url =
        Uri.parse('https://routify.cyclic.app/api/${widget.userid}/location');
    final response = await http.post(url, body: {
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
    });

    if (response.statusCode == 200) {
      print('Location posted successfully');
      print('API Response: ${response.body}');
    } else {
      print('Failed to post location: ${response.statusCode}');
    }
  }

  Future<String> getUsernameById(String id) async {
    Response response =
        await get(Uri.parse('https://routify.cyclic.app/api/allusers'));
    final List<dynamic> responseData = json.decode(response.body);

    Map<String, dynamic>? matchingObject;
    for (var i = 0; i < responseData.length; i++) {
      if (responseData[i]['_id'] == id) {
        matchingObject = responseData[i];
        break;
      }
    }
    if (matchingObject != null) {
      String username = matchingObject['username'];
      var schedule = matchingObject['schedule'];

      for (final schedule in matchingObject['schedule']) {
        if (schedule['day'] == 'Monday') {
          isMonday = true;
        } else if (schedule['day'] == 'Tuesday') {
          isTuesday = true;
        } else if (schedule['day'] == 'Wednesday') {
          isWednesday = true;
        } else if (schedule['day'] == 'Thursday') {
          isThursday = true;
        } else if (schedule['day'] == 'Friday') {
          isFriday = true;
        } else if (schedule['day'] == 'Saturday') {
          isSaturday = true;
        }
      }

      //_username = username;
      print(username);
      //print(schedule);
      print(isMonday);
      print(isTuesday);
      print(isWednesday);
      print(isThursday);
      print(isFriday);
      print(isSaturday);
      return username;
      //print(username);
    }
    return "username";
  }

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
      bool msg;
      Map<String, dynamic> data = jsonDecode(response.body);
      msg = data['success'];
      if (msg == true) {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isFirstTimeKey = 'isFirstTime';

    // Get all the keys in SharedPreferences
    Set<String> keys = prefs.getKeys();

    // Loop through the keys and remove any that don't match isFirstTimeKey
    for (String key in keys) {
      if (key != isFirstTimeKey) {
        await prefs.remove(key);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("hello");
    // setState(() {
    _username = getUsernameById(widget.userid);
    //_getCurrentLocation();
    //print(_username);

    print(_username);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // getUsernameById(widget.userid).then((username) {
    //   setState(() {
    //     _username = username;
    //   });
// setState(() {
//       _username = getUsernameById(widget.userid);
//       //print(_username);

//       print(_username);
//     });
//     //print(_username);
    //_username = getUsernameById(widget.token);

//     print(_username);

    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.yellow,
          ))
        : FutureBuilder<String>(
            future: getUsernameById(widget.userid),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(
                        backgroundColor: Colors.black,
                        title: Text(widget.title,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30)),
                        leading: Builder(
                          builder: (BuildContext context) => IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      ),
                      drawer: Drawer(
                        child: Container(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ListView(
                              padding: EdgeInsets.only(left: 16.0),
                              children: <Widget>[
                                Container(
                                  height: 80,
                                  child: DrawerHeader(
                                    margin: EdgeInsets.zero,
                                    child: Text('',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 34.0,
                                            color: Colors.white)),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                DrawerItem(
                                    title: 'Profile',
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileScreen(
                                                    username: snapshot.data!,
                                                    userid: widget.userid,
                                                  ))).then((_) {
                                        setState(() {});
                                      });
                                    }),
                                DrawerItem(
                                    title: 'Day Settings',
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WeekScreen(
                                                            userid:
                                                                widget.userid)))
                                            .then((_) {
                                          setState(() {});
                                        });
                                      });
                                      //Navigator.pop(context);
                                    }),
                                DrawerItem(title: 'Requests', onTap: () {}),
                                DrawerItem(title: 'Settings', onTap: () {}),
                                DrawerItem(title: 'Help', onTap: () {}),
                                DrawerItem(
                                    title: 'Logout',
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                                "Are you sure you want to log out?"),
                                            actions: [
                                              TextButton(
                                                child: Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.blue)),
                                                onPressed: () {
                                                  clearSharedPreferences();
                                                  Navigator.pop(context);
                                                  _signOut(widget.token);
                                                },
                                              ),
                                              TextButton(
                                                child: Text('No',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: WillPopScope(
                        onWillPop: onWillPop,
                        child: SingleChildScrollView(
                          child: Container(
                            color: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Divider(
                                  height: 25,
                                  color: Colors.yellow,
                                  thickness: 8,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    DayCircle(
                                      onTap: () {
                                        if (isMonday) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyMapScreen(
                                                userid: widget.userid,
                                                day: "Monday",
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      isDay: isMonday,
                                      letter: "M",
                                      userid: widget.userid,
                                      day: "Monday",
                                    ),
                                    DayCircle(
                                      onTap: () {
                                        if (isTuesday) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyMapScreen(
                                                userid: widget.userid,
                                                day: "Tuesday",
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      isDay: isTuesday,
                                      letter: "T",
                                      userid: widget.userid,
                                      day: "Tuesday",
                                    ),
                                    DayCircle(
                                      onTap: () {
                                        if (isWednesday) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyMapScreen(
                                                userid: widget.userid,
                                                day: "Wednesday",
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      isDay: isWednesday,
                                      letter: "W",
                                      userid: widget.userid,
                                      day: "Wednesday",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    DayCircle(
                                      onTap: () {
                                        if (isThursday) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyMapScreen(
                                                userid: widget.userid,
                                                day: "Thursday",
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      isDay: isThursday,
                                      letter: "T",
                                      userid: widget.userid,
                                      day: "Thursday",
                                    ),
                                    DayCircle(
                                      onTap: () {
                                        if (isFriday) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyMapScreen(
                                                userid: widget.userid,
                                                day: "Friday",
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      isDay: isFriday,
                                      letter: "F",
                                      userid: widget.userid,
                                      day: "Friday",
                                    ),
                                    DayCircle(
                                      onTap: () {
                                        if (isSaturday) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyMapScreen(
                                                userid: widget.userid,
                                                day: "Saturday",
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {});
                                          });
                                        }
                                      },
                                      isDay: isSaturday,
                                      letter: "S",
                                      userid: widget.userid,
                                      day: "Saturday",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  height: 25,
                                  color: Colors.yellow,
                                  thickness: 8,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTodayDay() + '\'s Rides',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                getFormattedDate(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CollapsibleListScreen()));
                                              // Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             builder: (context) =>
                                              //                 EditProfileScreen(
                                              //                     username: snapshot
                                              //                         .data!,
                                              //                     userid: widget
                                              //                         .userid)))
                                              //     .then((_) {
                                              //   setState(() {});

                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             CollapsibleListScreen()));
                                            },
                                            child: Text("All Rides",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      //height: 270,

                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            _buildRow(),
                                            _buildRow(),
                                            _buildRow(),
                                            _buildRow()
                                          ],
                                        ),
                                      ),
                                    ),

                                    //_buildRow(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                );
              }
            });
  }
}

Widget _buildDayCircle(BuildContext context, bool isDay, String letter,
    String userid, String day) {
  return InkWell(
    onTap: () {
      if (isDay) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyMapScreen(userid: userid, day: day),
          ),
        ); // Move this line outside the `then` function
      }
    },
    child: Container(
      width: 90.0,
      height: 90.0,
      decoration: BoxDecoration(
        color: isDay ? Colors.yellow : Colors.deepOrange,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

String getTodayDay() {
  final now = DateTime.now();
  print(now);
  switch (now.weekday) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return 'Unknown day';
  }
}

String getFormattedDate() {
  DateTime now = DateTime.now();

  // Get the day suffix (st, nd, rd, or th)
  int day = now.day;
  String daySuffix;
  if (day % 10 == 1 && day != 11) {
    daySuffix = 'st';
  } else if (day % 10 == 2 && day != 12) {
    daySuffix = 'nd';
  } else if (day % 10 == 3 && day != 13) {
    daySuffix = 'rd';
  } else {
    daySuffix = 'th';
  }

  // Format the date as "dS Month"
  String formattedDate =
      '${now.day}$daySuffix ${DateFormat('MMMM').format(now)}';
  return formattedDate;
}

Widget _buildRow() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.yellow,
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: EdgeInsets.all(8.0),
    margin: EdgeInsets.all(8.0),
    child: Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text('Emaad',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          width: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // Handle close button press
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                // Handle check button press
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Handle notifications button press
              },
            ),
          ],
        ),
      ],
    ),
  );
}

DateTime? currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      currentBackPressTime != null &&
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: 'Press back button again to exit the app.');
    return Future.value(false);
  }
  return Future.value(true);
}
