import 'package:flutter/material.dart';

class DayTimings extends StatefulWidget {
  final String dayOfWeek;

  DayTimings({required this.dayOfWeek});

  @override
  _DayTimingsState createState() => _DayTimingsState();
}

class _DayTimingsState extends State<DayTimings> {
  String _firstSlot = 'Main Campus';
  String _lastSlot = 'Main Campus';
  bool isDriverSelected = false;

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
            padding: const EdgeInsets.all(8.0),
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
                    child: Text(
                      'First Slot',
                      style: TextStyle(color: Colors.black),
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
                      items: <String>['Main Campus', 'City Campus']
                          .map((String value) {
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
            padding: const EdgeInsets.all(8.0),
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
                    child: Text('Last Slot',
                        style: TextStyle(color: Colors.black)),
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
                      items: <String>['Main Campus', 'City Campus']
                          .map((String value) {
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

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isDriverSelected = false;
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
          )

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
