import 'package:flutter/material.dart';
import 'assistant.dart'; // Import the assistant page file
import 'signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _token = '';
  bool _loading = false;

  Future<void> _login() async {
    // ... (rest of the login page code)
    final apiUrl = 'http://192.168.43.168:8000/api/auth/login';

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String token = data['access'];

        setState(() {
          _token = token;
        });

        // Navigate to the assistant page on successful login
        if (_token.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SpeechScreen(token: token)),
          );
        }
      }else if (response.statusCode == 401) {
          // Display error message on your interface when there is no account with the provided information
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login Failed'),
                content: Text('Invalid username or password. Please check your credentials.'),
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
      else {
        print('Failed to login. Status code: ${response.statusCode}');
        // ... (rest of the error handling code)
      }
    } catch (e) {
      print('Error during login: $e');
      // ... (rest of the error handling code)
    } finally {
      setState(() {
        _loading = false;
      });
      // ... (rest of the finally code)
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
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
        child: Stack(
          children: [
            // Background Image
            
            /*
            Image.asset(
              "assets/images/vector-1.png",
              width: 413,
              height: 457,
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
            */
        
            Column(
            
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
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? CircularProgressIndicator()
                      : Text('Login'),
                ),
                SizedBox(height: 16.0),
                Text(_token),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: _navigateToSignUp,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
