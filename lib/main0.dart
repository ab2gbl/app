import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SpeechScreen(),
    );
  }
}
class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights={
    'joke': HighlightedWord(
      onTap: () => print('joke'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      )

    ),
    'poem': HighlightedWord(
      onTap: () => print('poem'),
      textStyle: const TextStyle(
        fontSize: 32.0,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      )

    ),
    
  };
  stt.SpeechToText _speech=stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0 ;


  @override
  void initState() {
    // TODO: implement initState
    _speech=stt.SpeechToText();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        //endRadius: 60.0,
        duration: const Duration(milliseconds: 2000),
        //repeatPauseDuaration: const Duration(milliseconds: 200),
        repeat: true,
        child:FloatingActionButton(
          onPressed: _listen,//_listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        )
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ), 
        ),
      ),
    );
  }

  void _listen() async{
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if(available){
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => setState((){
          _text = val.recognizedWords;
          if( val.hasConfidenceRating && val.confidence>0){
            _confidence = val.confidence;
          }
        }),
      );
    }else{
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}