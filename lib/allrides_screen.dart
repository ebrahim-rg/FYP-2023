import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AllRides extends StatefulWidget {
  AllRides({
    required this.userid,
  });

  final String userid;

  @override
  State<AllRides> createState() => _AllRidesState();
}

class _AllRidesState extends State<AllRides> {
  bool _isLoading = false;
  Future<List<Map<String, dynamic>>>? schedule;

  Future<List<Map<String, dynamic>>> getSchedule(String id) async {
    final response =
        await http.get(Uri.parse('https://routify.cyclic.app/api/allusers'));
    final List<dynamic> responseData = json.decode(response.body);

    Map<String, dynamic>? matchingObject;
    for (var i = 0; i < responseData.length; i++) {
      if (responseData[i]['_id'] == id) {
        matchingObject = responseData[i];
        break;
      }
    }

    if (matchingObject != null) {
      final schedule1 = matchingObject['schedule'];

      if (schedule1 != null && schedule1.isNotEmpty) {
        return matchingObject['schedule'].cast<Map<String, dynamic>>();
      }
    }

    return [];
  }

  Future<void> acceptRequest(String userId, String day) async {
    setState(() {
      _isLoading = true; // Show loading icon
    });

    try {
      final url = Uri.parse(
          'https://routify.cyclic.app/api/acceptgoing/${widget.userid}/$day');
      final response = await http.post(
        url,
        body: {'s_userid': userId}, // Include s_userid in the request body
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Request sent successfully');
        setState(() {
          schedule = getSchedule(widget.userid); // Update the schedule
        });

        // Refresh the screen after successful request acceptance
        // You can update the data source or make an API call to fetch the updated data
        // For simplicity, let's assume we're just setting a delay of 2 seconds
        await Future.delayed(Duration(seconds: 2));

        setState(() {
          _isLoading = false; // Hide loading icon
        });
      } else {
        throw Exception('Failed to accept request');
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Hide loading icon
      });
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    schedule = getSchedule(widget.userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'All Rides',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getSchedule(widget.userid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.yellow,),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              final schedule = snapshot.data;
              if (schedule != null && schedule.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    // Handle refresh logic here
                    // You can make an API call or update the data source
                    // For simplicity, let's assume we're just setting a delay of 2 seconds
                    await Future.delayed(Duration(seconds: 2));

                    setState(() {
                      //schedule =
                          //getSchedule(widget.userid); // Update the schedule
                    });
                  },
                  child: ListView.builder(
                    itemCount: schedule.length,
                    itemBuilder: (context, index) {
                      final day = schedule[index]['day'];
                      final acceptGoing = schedule[index]['accept_going'];
                      final acceptComing = schedule[index]['accept_coming'];

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
                            if (acceptGoing.isNotEmpty)
                              buildRequestList('Going', acceptGoing, day),
                            if (acceptComing.isNotEmpty)
                              buildRequestList('Coming', acceptComing, day),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text("You currently have no requests."),
                );
              }
            }
          },
        ),
      ),
    );
  }

  
  Widget buildRequestList(String type, List<dynamic> requests, String day) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'People $type:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: Colors.yellow,), // Show loading icon
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final username = requests[index]['username'];
                final email = requests[index]['email'];
                final erp = requests[index]['erp'];
                final requestId = requests[index]['id'];

                final trailingIcon = type == 'Going'
                    ? Icon(Icons.arrow_right, color: Colors.black, size: 25,) // Arrow pointing right for accept going
                    : Icon(Icons.arrow_left, color: Colors.black); // Arrow pointing left for accept coming

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(),
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
                    trailing: trailingIcon,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
