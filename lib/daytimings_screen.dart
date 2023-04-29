import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DayTimings extends StatefulWidget {
  final String dayOfWeek;
  String userid;

  DayTimings({required this.dayOfWeek, required this.userid});

  @override
  _DayTimingsState createState() => _DayTimingsState();
}

class _DayTimingsState extends State<DayTimings> {
  Future<void> updateSchedule(
    //String userId,
    //String day,
    String startTime,
    String endTime,
    String startCampus,
    String endCampus,
    String role,
    //BuildContext context,
  ) async {
    final url = Uri.parse(
        'https://routify.cyclic.app/api/users/shedule/${widget.userid}/${widget.dayOfWeek}');
    //final headers = {'Content-Type': 'application/json'};
    final body = ({
      'start_time': startTime,
      'end_time': endTime,
      'start_campus': startCampus,
      'end_campus': endCampus,
      'role': role,
    });

    try {
      final response = await put(url, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text('Day updated successfully'),
            ),
          ),
        );
      } else {
        print('Error updating schedule. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating schedule: $e');
    }
  }

  void setDay(String day, String startTime, String endTime, String startCampus,
      String endCampus, String role) async {
    Response response = await post(
      Uri.parse(
          'https://routify.cyclic.app/api/users/${widget.userid}/schedule'),
      body: {
        "day": day,
        "start_time": startTime,
        "end_time": endTime,
        "start_campus": startCampus,
        "end_campus": endCampus,
        "role": role,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Day set successfully'),
        ),
      );
    } else {
      throw Exception('Failed to set day');
    }
  }

  String startTime = "First Slot";
  String endTime = "First Slot";
  String _firstSlot = 'main';
  String _lastSlot = 'main';
  bool isDriverSelected = false;
  String role = "passenger";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.dayOfWeek,
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 30, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.yellow,
            thickness: 8,
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: Colors.yellow,
                      value: startTime,
                      onChanged: (String? newValue) {
                        print(_firstSlot);
                        print(_lastSlot);
                        print(startTime);
                        print(endTime);
                        print(role);
                        setState(() {
                          startTime = newValue!;
                        });
                        // TODO: Implement onChanged callback
                      },
                      items: <String>[
                        'First Slot',
                        'Second Slot',
                        'Third Slot',
                        'Fourth Slot',
                        'Fifth Slot',
                        'Sixth Slot',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _firstSlot,
                      onChanged: (String? newValue) {
                        setState(() {
                          _firstSlot = newValue!;
                        });
                      },
                      items: <String>['main', 'city'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: Colors.yellow,
                      value: endTime,
                      onChanged: (String? newValue) {
                        // TODO: Implement onChanged callback
                        setState(() {
                          endTime = newValue!;
                        });
                      },
                      items: <String>[
                        'First Slot',
                        'Second Slot',
                        'Third Slot',
                        'Fourth Slot',
                        'Fifth Slot',
                        'Sixth Slot',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _lastSlot,
                      onChanged: (String? newValue) {
                        setState(() {
                          _lastSlot = newValue!;
                        });
                      },
                      items: <String>['main', 'city'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
          Spacer(),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isDriverSelected = false;
                      role = 'passenger';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDriverSelected ? Colors.black : Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Text(
                    'Passenger',
                    style: TextStyle(
                      color: isDriverSelected ? Colors.yellow : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isDriverSelected = true;
                      role = 'driver';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDriverSelected ? Colors.yellow : Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Text(
                    'Driver',
                    style: TextStyle(
                      color: isDriverSelected ? Colors.black : Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  setDay(widget.dayOfWeek, startTime, endTime, _firstSlot,
                      _lastSlot, role);
                }); // TODO: Implement onPressed callback
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(double.infinity, 48.0),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          //   ElevatedButton(
          //       onPressed: null,
          //       style:
          //           ElevatedButton.styleFrom(backgroundColor: Colors.black),
          //       child: Text('Passenger',
          //           style: TextStyle(color: Colors.yellow))),
          //   SizedBox(width: 8),
          //   ElevatedButton(
          //       onPressed: null,
          //       style:
          //           ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
          //       child: Text('Driver', style: TextStyle(color: Colors.yellow))),
          // ])
        ],
      ),
    );
  }
}
