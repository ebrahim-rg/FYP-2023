import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DayTimings extends StatefulWidget {
  final String dayOfWeek;
  final String userid;

  DayTimings({
    required this.dayOfWeek,
    required this.userid,
  });

  @override
  _DayTimingsState createState() => _DayTimingsState();
}

class _DayTimingsState extends State<DayTimings> {
  String _startTime = 'First Slot';
  String _endTime = 'First Slot';
  String _startLocation = 'main';
  String _endLocation = 'main';
  String _role = 'passenger';

  Future<void> _saveSchedule() async {
    try {
      final url = Uri.parse(
          'https://routify.cyclic.app/api/users/shedule/${widget.userid}/${widget.dayOfWeek}');
      final body = {
        'start_time': _startTime,
        'end_time': _endTime,
        'start_campus': _startLocation,
        'end_campus': _endLocation,
        'role': _role,
      };
      final response = await put(url, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Schedule updated successfully.'),
          ),
        );
      } else {
        print('Error updating schedule. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating schedule: $e');
    }
  }

  Future<void> _setSchedule() async {
    try {
      final url = Uri.parse(
          'https://routify.cyclic.app/api/users/${widget.userid}/schedule');
      final body = {
        'day': widget.dayOfWeek,
        'start_time': _startTime,
        'end_time': _endTime,
        'start_campus': _startLocation,
        'end_campus': _endLocation,
        'role': _role,
      };
      final response = await post(url, body: body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Schedule set successfully.'),
          ),
        );
      } else {
        throw Exception('Failed to set schedule.');
      }
    } catch (e) {
      print('Error setting schedule: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.dayOfWeek.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'START',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _startTime,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _startTime = value!;
                          });
                        },
                        items: [
                          'First Slot',
                          'Second Slot',
                          'Third Slot',
                          'Fourth Slot',
                          'Fifth Slot',
                          'Sixth Slot',
                        ].map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _startLocation,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _startLocation = value!;
                          });
                        },
                        items: [
                          'main',
                          'city',
                        ].map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'END',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _endTime,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _endTime = value!;
                          });
                        },
                        items: [
                          'First Slot',
                          'Second Slot',
                          'Third Slot',
                          'Fourth Slot',
                          'Fifth Slot',
                          'Sixth Slot',
                        ].map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _endLocation,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _endLocation = value!;
                          });
                        },
                        items: [
                          'main',
                          'city',
                        ].map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ROLE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _role,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _role = value!;
                          });
                        },
                        items: [
                          'passenger',
                          'driver',
                        ].map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: ElevatedButton(
            //     onPressed: _saveSchedule,
            //     style: ElevatedButton.styleFrom(
            //       primary: Colors.black,
            //       padding: EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: Text(
            //       'UPDATE SCHEDULE',
            //       style: TextStyle(
            //         fontFamily: 'Poppins',
            //         fontSize: 14,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: _setSchedule,
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'SET SCHEDULE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
