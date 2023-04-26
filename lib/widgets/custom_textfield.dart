import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/poppins_text.dart';

class CustomTextfield extends StatefulWidget {
  CustomTextfield({
    super.key,
    required this.hintText,
    required this.sufix,
    required this.errorText,
    required this.textFieldController,
    required this.obscureText,
    required this.prefix,
  });

  final String hintText;
  final Widget sufix;
  final String? errorText;
  final TextEditingController textFieldController;
  final bool obscureText;
  final Widget prefix;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  String _enteredText = '';
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: TextFormField(
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return widget.errorText;
          }
          return null;
        },
        controller: widget.textFieldController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15, left: 16),
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: widget.prefix,
          suffixIcon: widget.sufix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        obscureText: widget.obscureText,
      ),
    );
  }
}
