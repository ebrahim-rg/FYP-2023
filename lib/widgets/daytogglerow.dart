import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DayToggleRow extends StatefulWidget {
  DayToggleRow(
      {required this.index, required this.isToggled, required this.onTap});
  int index;
  List<bool> isToggled;
  List<VoidCallback> onTap;

  @override
  State<DayToggleRow> createState() => _DayToggleRowState();
}

class _DayToggleRowState extends State<DayToggleRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          widget.isToggled[widget.index] ? widget.onTap[widget.index] : () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: widget.isToggled[widget.index]
                ? Colors.yellow
                : Colors.yellow[700],
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListTile(
            title: Text(
              [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ][widget.index],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 24,
              ),
            ),
            trailing: IconButton(
              iconSize: 40,
              icon: Icon(
                widget.isToggled[widget.index]
                    ? Icons.toggle_on
                    : Icons.toggle_off,
                color:
                    widget.isToggled[widget.index] ? Colors.black : Colors.grey,
              ),
              onPressed: () => setState(() {
                widget.isToggled[widget.index] =
                    !widget.isToggled[widget.index];
              }),
            ),
          ),
        ),
      ),
    );
  }
}
