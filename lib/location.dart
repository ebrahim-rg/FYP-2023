import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? _selectedLatLng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (LatLng latLng) {
                  // This callback will be called whenever the user taps on the map
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
    const url =
        'https://routify.cyclic.app/api/644c24f83c29b04953977883/location';
    Response response = await http.post(
      Uri.parse(url),
      body: {
        'latitude': latLng.latitude.toString(),
        'longitude': latLng.longitude.toString(),
      },
    );
    if (response.statusCode == 200) {
      //final responseData = json.decode(response.body);
      //print(response);
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location has been set successfully"),
          ),
        );
      });
      //return response;
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
