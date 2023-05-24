import 'dart:convert';
import 'package:flutter/material.dart';

class RequestsList extends StatelessWidget {
  final List<dynamic> schedule;

  RequestsList(this.schedule);

  @override
  Widget build(BuildContext context) {
    List<dynamic> allRequests = [];

    for (var day in schedule) {
      final List<dynamic> requestsSent = day['request_sent'];
      allRequests.addAll(requestsSent);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Rides',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: allRequests.length,
            itemBuilder: (context, index) {
              final request = allRequests[index];
              final username = request['username'];
              final email = request['email'];
              final erp = request['erp'];

              return Card(
                color: Colors.yellow,
                child: ListTile(
                  leading: Icon(
                    Icons.people,
                    color: Colors.blue,
                    size: 40,
                  ),
                  title: Text(
                    username,
                    style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        erp,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Perform any desired action on tile tap
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}