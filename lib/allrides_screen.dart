import 'package:flutter/material.dart';

class CollapsibleListScreen extends StatefulWidget {
  @override
  _CollapsibleListScreenState createState() => _CollapsibleListScreenState();
}

class _CollapsibleListScreenState extends State<CollapsibleListScreen> {
  List<bool> _isOpenList = [false, false, false, false, false, false, false];
  final List<String> _dayOfWeekList = [    'Monday',    'Tuesday',    'Wednesday',    'Thursday',    'Friday',    'Saturday',    'Sunday'  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Weekly Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _dayOfWeekList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOpenList[index] = !_isOpenList[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dayOfWeekList[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          _isOpenList[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 28.0,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isOpenList[index]) ...[
                  SizedBox(height: 16.0),
                  _buildSubListTile('Ebad'),
                  _buildSubListTile('Affan'),
                  _buildSubListTile('Ali Azeem'),
                  _buildSubListTile('Emaad'),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubListTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
