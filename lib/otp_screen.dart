import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';

import 'signin_screen.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/poppins_text.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();

  void _showResponse(email, otp) async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response = await post(
          Uri.parse('https://routify.cyclic.app/api/verify-otp'),
          body: {"email": email, "otp": otp});
      String msg = '';
      Map<String, dynamic> data = jsonDecode(response.body);
      msg = data['message'];
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            content: Text(
              msg,
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  onPressed: () {
                    if (response.statusCode == 200) {
                      // Navigate to the next page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Color(0xff09101d),
        appBar: AppBar(
          backgroundColor: Color(0xff09101d),
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //physics: const ClampingScrollPhysics(),
          children: [
            Form(
              //key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: [
                    // Heading
                    //SizedBox(height: 200,),
                    poppinsText(
                      text: 'Enter OTP',
                      size: 48.0,
                      fontBold: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 30),

                    // Email
                    CustomTextfield(
                        hintText: 'Email',
                        prefix: Icon(
                          Icons.email,
                          color: Colors.yellow,
                        ),
                        sufix: const SizedBox(),
                        errorText: 'Enter a valid email',
                        textFieldController: email,
                        obscureText: false),

                    const SizedBox(height: 15),

                    // Password
                    CustomTextfield(
                        hintText: 'OTP',
                        sufix: const SizedBox(),
                        errorText: 'OTP cannot be empty',
                        textFieldController: otp,
                        obscureText: true,
                        prefix: Icon(
                          Icons.lock,
                          color: Colors.yellow,
                        )),

                    // Signin Button
                    CustomButton(
                      text: 'Verify OTP',
                      onTap: () {
                        _showResponse(
                            email.text.toString(), otp.text.toString());
                      },
                     
                      color1: Colors.yellow,
                      color2: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      if (isLoading)
        Center(
          //heightFactor: 1,
          child: CircularProgressIndicator(
            color: Colors.yellow,
          ),
        ),
    ]);
  }
}
