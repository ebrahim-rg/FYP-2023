import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/home_screen.dart';
import 'package:fyp/otp_screen.dart';
import 'package:fyp/signin_screen.dart';
import 'package:http/http.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/poppins_text.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  //String msg = "";
  String otp = '';

  final username = TextEditingController();
  final erp = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final contact = TextEditingController();

  void _showResponse(username, email, password, erp,contact) async {
    setState(() {
      isLoading = true;
    });

    try {
      Response response =
          await post(Uri.parse('https://routify.cyclic.app/api/signup'), body: {
        "username": username,
        "email": email,
        "password": password,
        "erp": erp,
        "contact":contact
      });
      String msg = '';
      Map<String, dynamic> data = jsonDecode(response.body);
      msg = data['message'];
      //String otp = data["otp"];
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
                    if (response.statusCode == 201) {
                      // Navigate to the next page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => OTP()),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    response.statusCode == 201 ? "Verify OTP" : "OK",
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
  void initState() {
    super.initState();
    email;
    password;
    username;
    erp;
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    erp.dispose();
    username.dispose();
  }

  Future<String> signup(String username, email, password, erp, contact) async {
    Response response =
        await post(Uri.parse('https://routify.cyclic.app/api/signup'), body: {
      "username": username,
      "email": email,
      "password": password,
      "erp": erp,
      "contact": contact
    });
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception("Failed to create account");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xff09101d),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff09101d),
            elevation: 0,
            //leading: backButton(),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Form(
                //key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      poppinsText(
                        text: 'Create your \nAccount',
                        size: 30.0,
                        fontBold: FontWeight.bold,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),

                      CustomTextfield(
                          hintText: 'Username',
                          sufix: const SizedBox(),
                          errorText: 'Username cannot be empty',
                          textFieldController: username,
                          obscureText: false,
                          prefix: Icon(
                            Icons.email,
                            color: Colors.yellow,
                          )),
                      const SizedBox(height: 15),

                      // Email
                      CustomTextfield(
                          hintText: 'Email',
                          sufix: const SizedBox(),
                          errorText: 'Email cannot be empty',
                          textFieldController: email,
                          obscureText: false,
                          prefix: Icon(
                            Icons.email,
                            color: Colors.yellow,
                          )),
                      const SizedBox(height: 15),

                      //Password
                      CustomTextfield(
                          hintText: 'Password',
                          sufix: const SizedBox(),
                          errorText: 'Password cannot be empty',
                          textFieldController: password,
                          obscureText: true,
                          prefix: Icon(
                            Icons.lock,
                            color: Colors.yellow,
                          )),
                      const SizedBox(height: 20),

                      CustomTextfield(
                          hintText: 'Contact no.',
                          sufix: const SizedBox(),
                          errorText: 'Contact cannot be empty',
                          textFieldController: contact,
                          obscureText: false,
                          prefix: Icon(
                            Icons.email,
                            color: Colors.yellow,
                          )),
                      const SizedBox(height: 15),

                      CustomTextfield(
                          hintText: 'ERP',
                          sufix: const SizedBox(),
                          errorText: 'ERP cannot be empty',
                          textFieldController: erp,
                          obscureText: false,
                          prefix: Icon(
                            Icons.email,
                            color: Colors.yellow,
                          )),
                      const SizedBox(height: 15),

                      // Signup Button
                      CustomButton(
                        isLoading: isLoading,
                        text: 'Sign Up',
                        onTap: (() {
                          _showResponse(
                              username.text.toString(),
                              email.text.toString(),
                              password.text.toString(),
                              erp.text.toString(),
                              contact.text.toString());
                        }),
                        color1: Colors.yellow,
                        color2: Colors.black,
                      ),
                      const SizedBox(height: 10),

                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Container(
                      //         height: 1.5,
                      //         color: const Color(0xffEEEEEE),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 14),
                      //     Text(
                      //       'or continue with',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //     const SizedBox(width: 14),
                      //     Expanded(
                      //       child: Container(
                      //         height: 1.5,
                      //         color: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      //const SizedBox(height: 20),

                      // Already have an account
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            poppinsText(
                              text: 'Already have an account? ',
                              size: 14.0,
                              fontBold: FontWeight.w500,
                              color: Colors.white,
                            ),
                            poppinsText(
                              text: 'Sign In',
                              size: 14.0,
                              fontBold: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // if (isLoading)
        //   Center(
        //     //heightFactor: 1,
        //     child: CircularProgressIndicator(
        //       color: Colors.black,
        //     ),
        //   ),
      ],
    );
  }
}
