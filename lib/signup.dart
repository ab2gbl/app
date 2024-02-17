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
  String _detail = '';
  String _password= '';
  String _error = '';

  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Username and password are required';
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign Up Failed'),
            content: Text(_error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    }

    // Replace with your API endpoint for signing up
    final apiUrl = 'http://192.168.43.168:8000/api/auth/register';

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
      } else if (response.statusCode == 400) {
  // Display error message on your interface when there is an issue with provided information
  final Map<String, dynamic> data = json.decode(response.body);

  // Check if the 'username' key is present and is a list
  if (data.containsKey('username') && data['username'] is List) {
    final List<dynamic> usernameErrors = data['username'];

    if (usernameErrors.isNotEmpty) {
      setState(() {
        _error = usernameErrors[0]; // Taking the first error message, you can handle multiple messages if needed
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign Up Failed'),
            content: Text(_error),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
 else {
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
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        backgroundColor: Colors.deepPurple,
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
