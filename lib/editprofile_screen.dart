import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String userid;
  //final String lastName;

  EditProfileScreen({required this.username, required this.userid});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // String userid = widget.userid;

  Future<void> updateUser(
      String userId, String username, String password) async {
    final url = Uri.parse('https://routify.cyclic.app/api/users/$userId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'name': username, 'password': password});

    try {
      Response response = await put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('User updated successfully');
      } else {
        print('Failed to update user');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
    //passwordController.text = widget.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        //leading: InkWell(onTap: () {}, child: Icon(Icons.arrow_back)),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(color: Colors.yellow,thickness: 8,),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.yellow),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Enter new password",
                labelText: 'New Password',
                labelStyle: TextStyle(color: Colors.yellow),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                updateUser(widget.userid, usernameController.text.toString(),
                    passwordController.text.toString());
              },
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
