import 'package:flutter/material.dart';

class EmailTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final String errorText;
  final TextEditingController controller;
  bool showError;
  final bool obscure;

  EmailTextField({
    required this.hintText,
    required this.icon,
    required this.errorText,
    required this.controller,
    required this.showError,
    required this.obscure,
  });

  @override
  _EmailTextFieldState createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  bool _hasError = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscure,
      obscuringCharacter: "*",
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon:
            Icon(widget.icon, color: _isFocused ? Colors.yellow : Colors.grey),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: widget.showError ? Colors.red : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        errorText: widget.showError ? widget.errorText : null,
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        if (!value.isEmpty)
          setState(() {
            widget.showError = false;
          });
      },
      onTap: () {
        setState(() {
          _isFocused = true;
        });
      },
      onEditingComplete: () {
        setState(() {
          _isFocused = false;
        });
      },
    );
  }
}
