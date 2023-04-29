import 'package:flutter/material.dart';
import 'package:fyp/daytimings_screen.dart';
import 'package:fyp/widgets/daytogglerow.dart';

class WeekScreen extends StatefulWidget {
  //final String dayOfWeek;
  WeekScreen({required this.userid});
  String userid;

  //WeekScreen({Key key, this.dayOfWeek}) : super(key: key);

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  late List<VoidCallback> onTap;
  @override
  void initState() {
    super.initState();
    onTap = [
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Monday',userid: widget.userid,)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Tuesday',userid: widget.userid,)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Wednesday',userid: widget.userid,)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Thursday',userid: widget.userid,)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Friday',userid: widget.userid,)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Saturday',userid: widget.userid,)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Sunday',userid: widget.userid,)));
      },
    ];
  }

  List<bool> isToggled = [true, true, true, true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              //Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        backgroundColor: Colors.black,
        title: Text(
          "Day Settings",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 30),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.yellow,
            thickness: 8,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return DayToggleRow(
                    index: index, isToggled: isToggled, onTap: onTap);
              },
            ),
          ),
        ],
      ),
    );
  }
}
