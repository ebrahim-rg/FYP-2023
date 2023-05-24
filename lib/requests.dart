import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Requests extends StatefulWidget {
  Requests({required this.userid, required this.schedule});

  final String userid;
  final List<dynamic> schedule;

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    if (widget.schedule == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    final schedule = widget.schedule.cast<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Requests',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: schedule.length,
          itemBuilder: (context, index) {
            final day = schedule[index]['day'];
            final requestGoing = schedule[index]['request_going'];
            final requestComing = schedule[index]['request_coming'];

            return Card(
              color: Colors.yellow,
              child: ExpansionTile(
                title: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                children: [
                  if (requestGoing.isNotEmpty)
                    buildRequestList('Going', requestGoing),
                  if (requestComing.isNotEmpty)
                    buildRequestList('Coming', requestComing),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildRequestList(String type, List<dynamic> requests) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requests $type:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final username = requests[index]['username'];
              final email = requests[index]['email'];
              final erp = requests[index]['erp'];
              final requestId = requests[index]['_id'];

              return Card(
                child: ListTile(
                  title: Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(email, style: TextStyle(color: Colors.black)),
                      Text(erp, style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle tick icon tap
                        },
                        child: Icon(Icons.check, color: Colors.green),
                      ),
                      SizedBox(width: 16.0),
                      GestureDetector(
                        onTap: () {
                          // Handle cross icon tap
                        },
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
