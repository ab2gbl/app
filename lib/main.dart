import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'joke': HighlightedWord(
      onTap: () => print('joke'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'poem': HighlightedWord(
      onTap: () => print('poem'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech=stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  bool _speechEnabled = false;
  bool _isSpeechFinished = false;
  
  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speech.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _text = result.recognizedWords;
    });
    if (_speech.isNotListening) {
      _isSpeechFinished = true;
    }

    // Check if speech is finished and send the text to the API
    if (_isSpeechFinished) {
      _sendTextToAPI(_text);
      _isSpeechFinished = false; // Reset the flag
    }
  }

  Future<void> _sendTextToAPI(String text) async {
    final apiUrl = 'https://webhook.site/f8c9463d-6cb1-4dbe-b4a0-3b50dbf3ea8c'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'text': text},
      );

      if (response.statusCode == 200) {
        print('Text sent to API successfully');
        // You can handle the API response here if needed
      } else {
        print('Failed to send text to API. Status code: ${response.statusCode}');
        // Handle error
      }
    } catch (e) {
      print('Error sending text to API: $e');
      // Handle error
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: !_speech.isNotListening,
        glowColor: Theme.of(context).primaryColor,
        //endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        //repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _speech.isNotListening ? _startListening : _stopListening,
          child: Icon(_speech.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: 
            Column(
              children: [
              Text(
                _speech.isNotListening.toString(),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0), // Add some spacing
              TextHighlight(
                text: _text,
                words: _highlights,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              ]
            )
        ),
      ),
    );
  }

}