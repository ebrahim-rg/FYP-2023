import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DrawerItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 24.0, color: Colors.yellow)),
      onTap: onTap,
    );
  }
}
