import 'package:flutter/material.dart';

class CollapsibleListScreen extends StatefulWidget {
  @override
  _CollapsibleListScreenState createState() => _CollapsibleListScreenState();
}

class _CollapsibleListScreenState extends State<CollapsibleListScreen> {
  List<bool> _isOpenList = [false, false, false, false, false, false, false];
  List<String> _dayOfWeekList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      _dayOfWeekList[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    trailing: _isOpenList[index]
                        ? Icon(Icons.arrow_drop_up)
                        : Icon(Icons.arrow_drop_down),
                    onTap: () {
                      setState(() {
                        _isOpenList[index] = !_isOpenList[index];
                      });
                    },
                  ),
                ),
                _isOpenList[index]
                    ? Column(
                        children: <Widget>[
                          _buildSubListTile('Ebad'),
                          _buildSubListTile('Affan'),
                          _buildSubListTile('Ali Azeem'),
                          _buildSubListTile('Emaad'),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubListTile(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
