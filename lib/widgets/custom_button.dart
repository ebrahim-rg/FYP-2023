import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.isLoading = false,
      this.color1,
      this.color2})
      : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color? color1;
  final Color? color2;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: 400,
        height: 45,
        child: DecoratedBox(
          decoration: BoxDecoration(
            
            color: color1,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.6),
                blurRadius: 5,
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.black)
                  : Text(
                      text,
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        color: color2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
