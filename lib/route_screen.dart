import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  GoogleMapController? mapController;

  final LatLng _initialCameraPosition = LatLng(37.77483, -122.419416);

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("marker_1"),
          position: LatLng(37.77483, -122.419416),
          infoWindow: InfoWindow(title: "Marker 1"),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("marker_2"),
          position: LatLng(37.77493, -122.419516),
          infoWindow: InfoWindow(title: "Marker 2"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Route',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  //height: 30.0,
                  color: Colors.yellow,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    iconSize: 24.0,
                  ),
                ),
                Container(
                 // height: 30.0,
                  color: Colors.yellow,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.black,
                    iconSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.yellow,
            thickness: 2.0,
          ),
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialCameraPosition,
                zoom: 14.0,
              ),
              markers: _markers,
              onMapCreated: _onMapCreated,
            ),
          ),
        ],
      ),
    );
  }
}
