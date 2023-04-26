import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget poppinsText(
    {required text,
    required size,
    required FontWeight fontBold,
    required Color color}) {
  return Text(
    text,
    style:
        GoogleFonts.poppins(fontSize: size, fontWeight: fontBold, color: color),
  );
}