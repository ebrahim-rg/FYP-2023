import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "dart:ui" as ui;

import 'package:url_launcher/url_launcher_string.dart';

class MyMapScreen extends StatefulWidget {
  MyMapScreen({
    this.userid,
    this.day,
  });
  String? userid;
  String? day;
  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  late GoogleMapController mapController;
  List<Marker> _markers = [];
  Set<Polyline> _polylines = {};
  String hi = "original";
  String status = "going";

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Set<Polyline>> _getPolylines(String startLat, String startLng,
      String endLat, String endLng, List<Color> colors) async {
    final apiKey = 'AIzaSyBQDYflt-5xGe16hLqWa9415WEtwMffnEk';
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$startLat,$startLng'
        '&destination=$endLat,$endLng'
        '&mode=driving'
        '&alternatives=true'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> routes = decoded['routes'];
      Set<Polyline> polylines = {};
      for (int i = 0; i < routes.length; i++) {
        final points =
            _decodePolyline(routes[i]['overview_polyline']['points']);
        final polyline = Polyline(
          polylineId: PolylineId('route$i'),
          points: points,
          color: colors[i % colors.length],
          width: 5,
        );
        polylines.add(polyline);
      }
      return polylines;
    } else {
      throw Exception('Failed to fetch polylines');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];

    int index = 0;
    int lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      points.add(LatLng((lat / 1E5), (lng / 1E5)));
    }
    return points;
  }

  var lat;
  var lng;
  var destlat;
  var destlng;
  String? role;
  String? start_campus;

  Future<void> getLocation(String id) async {
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
      //String username = matchingObject['username'];
      //var schedule = matchingObject['schedule'];
      var location = matchingObject['location'][0];
      lat = location['latitude'];
      lng = location['longitude'];

      for (final schedule in matchingObject['schedule']) {
        if (schedule['day'] == widget.day) {
          role = schedule['role']!;
          start_campus = schedule['start_campus']!;
          print(role);
          print(start_campus);
          if (start_campus == 'main') {
            destlat = "24.9419";
            destlng = "67.1143";
          } else {
            destlat = "24.870296184680107";
            destlng = "67.02545990441794";
          }

          break;
        }
      }

      // //_username = username;
      // print(username);
      // //print(schedule);
      // print(isMonday);
      // print(isTuesday);
      // print(isWednesday);
      // print(isThursday);
      // print(isFriday);
      // print(isSaturday);
      // return username;
      // //print(username);
    }
    //return "username";
  }

  Uint8List? markerImage;

  Future<Uint8List> getByteFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> sendRequest(BuildContext context, String s) async {
    print(status);
    final url = Uri.parse(
        'https://routify.cyclic.app/api/request$status/${widget.userid}/${widget.day}');

    try {
      final response = await http.post(
        url,
        body: {
          's_userid': s,
        },
      );
      print('hi');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Request sent');
        Navigator.of(context).pop();
        //Navigator.of(context).pop();
      } else {
        print('POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during POST request: $e');
    }
  }

  Future<void> _fetchDatagoing() async {
    final Uint8List avatarIcon =
        await getByteFromAssets("assets/images/avatar.png", 45);
    final Uint8List carIcon =
        await getByteFromAssets("assets/images/car.png", 45);

    final response = await http.get(Uri.parse(
        'https://routify.cyclic.app/api/matches_uni/${widget.userid}/${widget.day}'));

    if (response.statusCode == 200) {
      print(response.body);

      //print(data["filtered_users"].length);
      if (response.body == "no one is available") {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No matches available. Sorry!'),
            ),
          );
        });
      } else {
        final data = jsonDecode(response.body);
        print(data);

        //lat = data['filtered_users'][0]['location'][0]["latitude"];
        //lng = data['filtered_users'][0]['location'][0]["longitude"];
        print(lat);
        print(lng);
        print(role);
        print(start_campus);
        List<Marker> markers = [];
        // print(lat);
        // print(lng);

        for (var user in data['filtered_users']) {
          print(user["_id"]);
          final location = user['location'][0];
          final marker = Marker(
            icon: role == 'driver'
                ? BitmapDescriptor.fromBytes(avatarIcon)
                : BitmapDescriptor.fromBytes(avatarIcon),
            markerId: MarkerId(user['username']),
            position: LatLng(
              double.parse(location['latitude']),
              double.parse(location['longitude']),
            ),
            infoWindow: InfoWindow(
              title: user['username'],
              snippet: 'ERP: ${user['erp']} Email: ${user['email']}',
              // Customized InfoWindow
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(user['username']),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ERP: ${user['erp']}',
                            style: TextStyle(color: Colors.blue)),
                        SizedBox(height: 4),
                        Text('Email: ${user['email']}',
                            style: TextStyle(color: Colors.blue)),
                        SizedBox(height: 4,),
                        Text('${user['schedule'][0]['role']}'.toUpperCase(),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),

                        //SizedBox(height: 8),
                        // Text('Location:', style: TextStyle(color: Colors.grey)),
                        // Text(
                        //   '${location['latitude']}, ${location['longitude']}',
                        //   style: TextStyle(color: Colors.blue),
                        // ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Open WhatsApp with the user's number
                          launch('https://wa.me/${user['contact']}');
                        },
                        child: Text('WhatsApp'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Send a request
                          sendRequest(context, user["_id"]);
                        },
                        child: Text('Send Request'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
          markers.add(marker);
          role = "passenger";
        }

        final polyline = await _getPolylines(lat, lng, destlat, destlng,
            [Colors.blue, Colors.green, Colors.purple]);
        print(polyline);
        setState(() {
          _polylines = polyline;
          print(polyline);
        });

        setState(() {
          _markers = markers;
        });
      }
      //throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchDatacoming() async {
    final Uint8List avatarIcon =
        await getByteFromAssets("assets/images/avatar.png", 45);
    final Uint8List carIcon =
        await getByteFromAssets("assets/images/car.png", 45);

    final response = await http.get(Uri.parse(
        'https://routify.cyclic.app/api/matches_home/${widget.userid}/${widget.day}'));

    if (response.statusCode == 200) {
      print(response.body);

      //print(data["filtered_users"].length);
      if (response.body == "no one is available") {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No matches available. Sorry!'),
            ),
          );
        });
      } else {
        final data = jsonDecode(response.body);
        print(data);

        //lat = data['filtered_users'][0]['location'][0]["latitude"];
        //lng = data['filtered_users'][0]['location'][0]["longitude"];
        print(lat);
        print(lng);
        print(role);
        print(start_campus);
        List<Marker> markers = [];
        // print(lat);
        // print(lng);

        for (var user in data['filtered_users']) {
          final location = user['location'][0];
          final marker = Marker(
            icon: role == 'driver'
                ? BitmapDescriptor.fromBytes(carIcon)
                : BitmapDescriptor.fromBytes(avatarIcon),
            markerId: MarkerId(user['username']),
            position: LatLng(
              double.parse(location['latitude']),
              double.parse(location['longitude']),
            ),
            infoWindow: InfoWindow(
              title: user['username'],
              snippet: 'ERP: ${user['erp']} Email: ${user['email']}',
              // Customized InfoWindow
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(user['username']),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ERP: ${user['erp']}',
                            style: TextStyle(color: Colors.blue)),
                        SizedBox(height: 4),
                        Text('Email: ${user['email']}',
                            style: TextStyle(color: Colors.blue)),
                        // SizedBox(height: 8),
                        // Text('Location:', style: TextStyle(color: Colors.grey)),
                        // Text(
                        //   '${location['latitude']}, ${location['longitude']}',
                        //   style: TextStyle(color: Colors.blue),
                        // ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Open WhatsApp with the user's number
                          launch('https://wa.me/${user['contact']}');
                        },
                        child: Text('WhatsApp'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Send a request
                          sendRequest(context, user["_id"]);
                        },
                        child: Text('Send Request'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
          markers.add(marker);
          role = "passenger";
        }

        final polyline = await _getPolylines(lat, lng, destlat, destlng,
            [Colors.blue, Colors.green, Colors.purple]);
        print(polyline);
        setState(() {
          _polylines = polyline;
          print(polyline);
        });

        setState(() {
          _markers = markers;
        });
      }
      //throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    print("hello");
    getLocation(widget.userid!);
    // setState(() {
    //_username = getUsernameById(widget.userid);
    //_getCurrentLocation();
    //print(_username);

    //print(_username);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.day!,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 25,
            color: Colors.yellow,
            thickness: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _fetchDatagoing();
                  status = "coming";
                  setState(() {}); // Handle going to uni button press
                },
                icon: Icon(Icons.arrow_forward, color: Colors.black),
                label: Text(
                  'Going to Uni',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              ElevatedButton.icon(
                onPressed: () {
                  _fetchDatacoming();
                  status = "going";
                  setState(() {});
                  // Handle going home button press
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
                label: Text(
                  'Going Home',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(24.9150, 67.0893), // Karachi, Pakistan
                    zoom: 11.0,
                  ),
                  markers: Set<Marker>.of(_markers),
                  polylines: _polylines),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _fetchData();
      //     hi = "changed";
      //     setState(() {});
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }
}
