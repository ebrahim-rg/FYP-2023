import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Routify/daysettings_screen.dart';
import 'package:Routify/widgets/textfield.dart';
import 'package:http/http.dart';

import 'home_screen.dart';
import 'signup_screen.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/poppins_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Save the data to shared preferences

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool isLogged = false;
  bool isChecked = false;
  bool emailshowError = false;
  bool pwshowError = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool validateUsername = true;
  bool validatePassword = true;
  //bool isFirstTime = true;
  //final formKey = GlobalKey<FormState>();

  Future<void> updateAuthState(bool isSignedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', isSignedIn);
  }

  Future<void> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  // Future<void> updateisFirstTime(bool flag) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isFirstTime', flag);
  // }

  // void _checkIfFirstTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  //   setState(() {
  //     this.isFirstTime = isFirstTime;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    email;
    password;
    //_checkIfFirstTime();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void _showResponse(email, password) async {
    setState(() {
      isLoading = true;
    });
    print("reaching code");

    try {
      print(password);
      print("hi");
      Response response =
          await post(Uri.parse('https://routify.cyclic.app/api/signin'), body: {
        "email": email,
        "password": password,
      });
      print("yo");
      String msg = '';
      String userid = '';
      String token = '';
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        msg = data['message'];
        token = data['token'];
        print(token);
        userid = data["userid"];
        print(token);
        print(userid);
      } else {
        Map<String, dynamic> data = jsonDecode(response.body);
        msg = data['msg'];
        //userid = '';
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            content: Text(
              textAlign: TextAlign.center,
              msg.toUpperCase(),
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
                      if (isChecked == true) {
                        updateAuthState(true);
                        saveToken(token);
                        saveUserId(userid);
                      }
                      Navigator.pop(context);
                      // Navigate to the next page

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                title: "Home", userid: userid, token: token)),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    //response.statusCode == 200 ?
                    "OK",
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                Form(
                  //key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 300,
                              child: Transform.scale(
                                scale: 0.75,
                                child: Image.asset(
                                  'assets/images/routify_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Heading

                        // poppinsText(
                        //   text: 'Login to your \nAccount',
                        //   size: 48.0,
                        //   fontBold: FontWeight.bold,
                        //   color: Colors.white,
                        // ),
                        // const SizedBox(height: 30),

                        // Email
                        EmailTextField(
                          hintText: "Email",
                          icon: Icons.email,
                          errorText: "* Email is required",
                          controller: email,
                          showError: emailshowError,
                          obscure: false,
                        )
                        // CustomTextfield(
                        //     hintText: 'Email',
                        //     prefix: Icon(
                        //       Icons.email,
                        //       color: Color(0xff246fdb),
                        //     ),
                        //     sufix: const SizedBox(),
                        //     errorText: 'Enter a valid email',
                        //     textFieldController: email,
                        //     obscureText: false),

                        ,
                        const SizedBox(height: 15),

                        // Password
                        EmailTextField(
                          hintText: "Password",
                          icon: Icons.lock,
                          errorText: "* Password is required",
                          controller: password,
                          showError: pwshowError,
                          obscure: true,
                        ),
                        // CustomTextfield(
                        //     hintText: 'Password',
                        //     sufix: const SizedBox(),
                        //     errorText: 'Password cannot be empty',
                        //     textFieldController: password,
                        //     obscureText: true,
                        //     prefix: Icon(
                        //       Icons.lock,
                        //       color: Color(0xff246fdb),
                        //     )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 1),
                                ),
                                child: isChecked
                                    ? Icon(
                                        Icons.check,
                                        size: 18,
                                        color: Colors.black,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Remember me',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),

                        // Signin Button
                        CustomButton(
                          isLoading: isLoading,
                          text: 'Sign In',
                          onTap: () {
                            print("it is working");
                            if (!email.text.isEmpty && !password.text.isEmpty) {
                              _showResponse(email.text.toString(),
                                  password.text.toString());
                              emailshowError = false;
                              pwshowError = false;
                            }
                            if (email.text.isEmpty && password.text.isEmpty) {
                              setState(() {
                                emailshowError = true;
                                pwshowError = true;
                              });
                            }
                            if (!email.text.isEmpty && password.text.isEmpty) {
                              setState(() {
                                emailshowError = false;
                                pwshowError = true;
                              });
                            }
                            if (email.text.isEmpty && !password.text.isEmpty) {
                              setState(() {
                                emailshowError = true;
                                pwshowError = false;
                              });
                            }
                          },
                          color1: Colors.yellow,
                          color2: Colors.black,
                        ),
                        const SizedBox(height: 8),
                        // Dont have an account
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              poppinsText(
                                text: 'Don\'t have an account? ',
                                size: 14.0,
                                fontBold: FontWeight.w500,
                                color: Colors.white,
                              ),
                              poppinsText(
                                text: 'Sign Up ',
                                size: 14.0,
                                fontBold: FontWeight.bold,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
