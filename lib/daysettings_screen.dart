import 'package:flutter/material.dart';
import 'package:fyp/daytimings_screen.dart';
import 'package:fyp/widgets/daytogglerow.dart';

class WeekScreen extends StatefulWidget {
  //final String dayOfWeek;

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
                builder: (context) => DayTimings(dayOfWeek: 'Monday')));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Tuesday')));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Wednesday')));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Thursday')));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Friday')));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Saturday')));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DayTimings(dayOfWeek: 'Sunday')));
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
