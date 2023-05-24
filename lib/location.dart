import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({required this.userid});

  String userid;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your home location',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(24.9150, 67.0893), // Karachi, Pakistan
                  zoom: 11.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (LatLng latLng) {
                  _showConfirmationDialog(latLng);
                },
                onMapCreated: (GoogleMapController controller) {
                  // You can use the controller to manipulate the map
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(LatLng latLng) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm location?'),
          content: Text('Lat: ${latLng.latitude}, Lng: ${latLng.longitude}'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _postLocationToApi(latLng);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _postLocationToApi(LatLng latLng) async {
    var url = 'https://routify.cyclic.app/api/${widget.userid}/location';
    Response response = await http.post(
      Uri.parse(url),
      body: {
        'latitude': latLng.latitude.toString(),
        'longitude': latLng.longitude.toString(),
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location has been set successfully"),
          ),
        );
      });
    } else {
      final responseData = json.decode(response.body);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['error']),
          ),
        );
      });
      throw Exception('Failed to post location');
    }
  }
}
