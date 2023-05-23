import 'package:flutter/material.dart';

class DayCircle extends StatefulWidget {
  //const DayCircle({super.key});
  DayCircle(
      {required this.letter,
      required this.isDay,
      required this.day,
      required this.userid,
      required this.onTap});
  String letter;
  bool isDay;
  String day;
  String userid;
  VoidCallback onTap;

  @override
  State<DayCircle> createState() => _DayCircleState();
}

class _DayCircleState extends State<DayCircle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 90.0,
        height: 90.0,
        decoration: BoxDecoration(
          color: widget.isDay ? Colors.yellow : Colors.deepOrange,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            widget.letter,
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
