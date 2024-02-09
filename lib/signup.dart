import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _token = '';
  bool _loading = false;

  Future<void> _signUp() async {
    // Replace with your API endpoint for signing up
    final apiUrl = 'http://192.168.1.106:8000/api/auth/register';

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
            "username": _usernameController.text.trim(),
            "password": _passwordController.text.trim()
        }
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        /*final String token = data['token'];

        setState(() {
          _token = token;
        });*/
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
        );
        

        // You can handle the signup response as needed

      } else {
        print('Failed to sign up. Status code: ${response.statusCode}');
        // Handle error
      }
    } catch (e) {
      print('Error during sign up: $e');
      // Handle error
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _loading ? null : _signUp,
              child: _loading
                  ? CircularProgressIndicator()
                  : Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            Text(_token),
          ],
        ),
      ),
    );
  }
}
