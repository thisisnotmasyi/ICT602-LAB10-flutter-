import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> apiData = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.0.28:8000/api/subject'), 
    headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      if (response.headers['content-type']?.contains('application/json') == true) {
        Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          if (responseData.containsKey('subject')) {
            apiData = responseData['subject'];
          }
          else {
            apiData = [];
          }
        });
      } 
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _revokeGoogleTokens() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out locally within your app
      await FirebaseAuth.instance.signOut();

      // Revoke Google tokens
      await _revokeGoogleTokens();

      // Navigate back to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print('Logout error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Container(
          color: Color(0xFFF4FBFE), // Background color
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('API Data:'),
              for (var item in apiData)
                ListTile(
                  title: Text(item['subject_code']),
                  subtitle: Text('Subject Code: ${item['subject_name']}'),
                ),
              ElevatedButton(
                onPressed: () async {
                  // Perform logout
                  await _logout(context);
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
