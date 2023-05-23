import 'package:flutter/material.dart';
import 'package:fyp/daytimings_screen.dart';

class WeekScreen extends StatefulWidget {
  WeekScreen({required this.userid});

  final String userid;

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
                builder: (context) =>
                    DayTimings(dayOfWeek: 'Monday', userid: widget.userid)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DayTimings(dayOfWeek: 'Tuesday', userid: widget.userid)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DayTimings(dayOfWeek: 'Wednesday', userid: widget.userid)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DayTimings(dayOfWeek: 'Thursday', userid: widget.userid)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DayTimings(dayOfWeek: 'Friday', userid: widget.userid)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DayTimings(dayOfWeek: 'Saturday', userid: widget.userid)));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DayTimings(dayOfWeek: 'Sunday', userid: widget.userid)));
      },
    ];
  }

  List<bool> isToggled = [true, true, true, true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Day Settings",
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 28, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                IconData icon;
                Color? color;
                switch (index) {
                  case 0:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                    break;
                  case 1:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                    break;
                  case 2:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                    break;
                  case 3:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                    break;
                  case 4:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                    break;
                  case 5:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                    break;
                  case 6:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                    break;
                  default:
                    icon = Icons.calendar_today;
                    color = Colors.blueGrey[700];
                }
                return InkWell(
                  onTap: isToggled[index] ? onTap[index] : () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: isToggled[index]
                            ? color!.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: Icon(
                          icon,
                          color: color,
                          size: 36,
                        ),
                        title: Text(
                          [
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday',
                            'Sunday'
                          ][index],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            fontSize: 20,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isToggled[index]
                                ? Icons.toggle_on_rounded
                                : Icons.toggle_off_rounded,
                            color: isToggled[index]
                                ? color
                                : Colors.grey.withOpacity(0.5),
                            size: 36,
                          ),
                          onPressed: () => setState(() {
                            isToggled[index] = !isToggled[index];
                          }),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}