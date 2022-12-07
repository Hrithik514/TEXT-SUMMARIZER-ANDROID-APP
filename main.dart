import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'dart:io';
import 'dart:convert';
import 'package:summarize/datamodel.dart'
    show dataModelFromJson, dataModelfromJson, datamodel;
import 'package:http/http.dart' as http;

import 'package:google_ml_kit/google_ml_kit.dart'
    show GoogleMlKit, InputImage, RecognisedText, TextBlock, TextLine;
import 'package:image_picker/image_picker.dart';
import 'package:summarize/output.dart';
//import 'package:flutter/services.dart';

//void main() => runApp(SpeechSampleApp());

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'SUMMARIZE YOUR TEXT';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Container(
            //color: Colors.green[200],
            child: const Text(
              'GIVE YOUR TEXT',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: Text(
              "TYPE YOUR TEXT",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Colors.blue,
              onSurface: Colors.white,
              side: BorderSide(color: Colors.black, width: 1),
              elevation: 20,
              minimumSize: Size(350, 70),
              //shadowColor: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyStatefulWidget2()),
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: Text(
              "GIVE YOUR TEXT THROUGH VOICE",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Colors.blue,
              onSurface: Colors.white,
              side: BorderSide(color: Colors.black, width: 1),
              elevation: 20,
              minimumSize: Size(350, 70),
              //shadowColor: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyStatefulWidget1()),
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: Text(
              "GIVE YOUR TEXT THROUGH LENS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Colors.blue,
              onSurface: Colors.white,
              side: BorderSide(color: Colors.black, width: 1),
              elevation: 20,
              minimumSize: Size(350, 70),
              //shadowColor: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyStatefulWidget4()),
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: Text(
              "ABOUT",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black,
              primary: Colors.greenAccent,
              onSurface: Colors.white,
              side: BorderSide(color: Colors.black, width: 1),
              elevation: 20,
              minimumSize: Size(150, 50),
              //shadowColor: Colors.teal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyStatefulWidget3()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyStatefulWidget1 extends StatefulWidget {
  const MyStatefulWidget1({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget1> createState() => SecondRoute();
}

/// An example that demonstrates the basic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
class SecondRoute extends State<MyStatefulWidget1> {
  bool _hasSpeech = false;
  bool _logEvents = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '20');
  final TextEditingController _listenForController =
      TextEditingController(text: '1000');
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
  }

  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.
  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SPEECH TO TEXT'),
        ),
        body: Column(children: [
          HeaderWidget(),
          Container(
            child: Column(
              children: <Widget>[
                InitSpeechWidget(_hasSpeech, initSpeechState),
                SpeechControlWidget(_hasSpeech, speech.isListening,
                    startListening, stopListening, cancelListening),
                SessionOptionsWidget(
                  _currentLocaleId,
                  _switchLang,
                  _localeNames,
                  _logEvents,
                  _switchLogging,
                  _pauseForController,
                  _listenForController,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: RecognitionResultsWidget(lastWords: lastWords, level: level),
          ),
          Expanded(
            flex: 1,
            child: ErrorWidget(lastError: lastError),
          ),
          SpeechStatusWidget(speech: speech),
        ]),
      ),
    );
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    // Note that `listenFor` is the maximum, not the minimun, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: listenFor ?? 1000),
        pauseFor: Duration(seconds: pauseFor ?? 20),
        partialResults: true,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
    });
  }
}

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    required this.lastWords,
    required this.level,
  }) : super(key: key);

  final String lastWords;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'Recognized Words',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.blue,
                shadowColor: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              onPressed: () async {
                String text1 = lastWords;
                var data1 = await submitdata(text1);
                print(text1);
                print(data1);
                /*setState(() {
                      _dataModel = data1;
                    });*/
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => nextpage(
                            summ: data1.toString(),
                          )),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "SUMMARIZE",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
            )),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).selectedRowColor,
                child: Center(
                  child: Text(
                    lastWords,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .26,
                            spreadRadius: level * 1.5,
                            color: Colors.black.withOpacity(.05))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () => null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '',
        style: TextStyle(fontSize: 22.0),
      ),
    );
  }
}

/// Display the current error status from the speech
/// recognizer
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    required this.lastError,
  }) : super(key: key);

  final String lastError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'Error Status',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Center(
          child: Text(lastError),
        ),
      ],
    );
  }
}

/// Controls to start and stop speech recognition
class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(this.hasSpeech, this.isListening,
      this.startListening, this.stopListening, this.cancelListening,
      {Key? key})
      : super(key: key);

  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;
  final void Function() stopListening;
  final void Function() cancelListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          child: Text('Start'),
        ),
        TextButton(
          onPressed: isListening ? stopListening : null,
          child: Text('Stop'),
        ),
        TextButton(
          onPressed: isListening ? cancelListening : null,
          child: Text('Cancel'),
        )
      ],
    );
  }
}

class SessionOptionsWidget extends StatelessWidget {
  const SessionOptionsWidget(
      this.currentLocaleId,
      this.switchLang,
      this.localeNames,
      this.logEvents,
      this.switchLogging,
      this.pauseForController,
      this.listenForController,
      {Key? key})
      : super(key: key);

  final String currentLocaleId;
  final void Function(String?) switchLang;
  final void Function(bool?) switchLogging;
  final TextEditingController pauseForController;
  final TextEditingController listenForController;
  final List<LocaleName> localeNames;
  final bool logEvents;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Text('Language: '),
              DropdownButton<String>(
                onChanged: (selectedVal) => switchLang(selectedVal),
                value: currentLocaleId,
                items: localeNames
                    .map(
                      (localeName) => DropdownMenuItem(
                        value: localeName.localeId,
                        child: Text(localeName.name),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          /*Row(
            children: [
              Text('pauseFor: '),
              Container(
                  padding: EdgeInsets.only(left: 8),
                  width: 80,
                  child: TextFormField(
                    controller: pauseForController,
                  )),
              Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('listenFor: ')),
              Container(
                  padding: EdgeInsets.only(left: 8),
                  width: 80,
                  child: TextFormField(
                    controller: listenForController,
                  )),
            ],
          ),
          Row(
            children: [
              Text('Log events: '),
              Checkbox(
                value: logEvents,
                onChanged: switchLogging,
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}

class InitSpeechWidget extends StatelessWidget {
  const InitSpeechWidget(this.hasSpeech, this.initSpeechState, {Key? key})
      : super(key: key);

  final bool hasSpeech;
  final Future<void> Function() initSpeechState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: hasSpeech ? null : initSpeechState,
          child: Text('Initialize'),
        ),
      ],
    );
  }
}

/// Display the current status of the listener
class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    Key? key,
    required this.speech,
  }) : super(key: key);

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: speech.isListening
            ? Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}

class MyStatefulWidget2 extends StatefulWidget {
  const MyStatefulWidget2({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget2> createState() => _MyStatefulWidgetState2();
}

Future<dynamic> submitdata(String text) async {
  try {
    var response =
        await http.post(Uri.https('summarizes.vercel.app', '/summarize'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({"text": text}));
    var data = response.body;

    print(data);

    var decodedJson = json.decode(data);
    String output = decodedJson['summarize'];
    print(decodedJson['summarize']);

    if (response.statusCode == 201) {
      String responseString = response.body;
      String summ = dataModelFromJson(responseString) as String;
      // print(summ);
      return output;
    } else {
      return output;
    }
  } catch (e) {
    print(e);
  }
}

class _MyStatefulWidgetState2 extends State<MyStatefulWidget2> {
  late datamodel _dataModel;

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SUMMARIZE YOUR TEXT"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                keyboardType: TextInputType.multiline,
                maxLines: 25,
                decoration: InputDecoration(
                    hintText: "Enter your text",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.redAccent))),
              ),
              ElevatedButton(
                  onPressed: () async {
                    String text1 = nameController.text;
                    var data1 = await submitdata(text1);
                    print(data1);
                    /*setState(() {
                      _dataModel = data1;
                    });*/
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => nextpage(
                                summ: data1.toString(),
                              )),
                    );
                  },
                  child: Text("SUMMARIZE"))
            ],
          ),
        ));
  }
}

class MyStatefulWidget3 extends StatefulWidget {
  const MyStatefulWidget3({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget3> createState() => _MyStatefulWidgetState3();
}

class _MyStatefulWidgetState3 extends State<MyStatefulWidget3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ABOUT OUR APP")),
      body: Center(
        child: Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.blueAccent,
          child: SizedBox(
            width: 370,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //CircleAvatar
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  SelectableText(
                    'This text summarization application summarizes the long format text to the shorter format with accurate meaning.'
                    'The application will have the separate modules of speech to text in order to convert natural language to text,'
                    'and the image to text feature which converts text in image to digital text.'
                    'The app is build  using NLP Libraries '
                    'The android application is built using android studio.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //Text
                  const SizedBox(
                    height: 30,
                  ),
                  SelectableText(
                    'DEVELOPED BY                                                   '
                    'Hrithik Hem Sundar.B                                             '
                    'Abishek.G',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //SizedBox
                  //Text
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  SizedBox(
                    width: 100,
                  ) //SizedBox
                ],
              ), //Column
            ), //Padding
          ), //SizedBox
        ), //Card
      ),
    );
  }
}

class MyStatefulWidget4 extends StatefulWidget {
  const MyStatefulWidget4({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget4> createState() => _MyStatefulWidget4();
}

class _MyStatefulWidget4 extends State<MyStatefulWidget4> {
  bool textScanning = false;

  XFile? imageFile;

  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TEXT FROM IMAGE"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey[300]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.blue,
                            shadowColor: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () async {
                            String text1 = scannedText;
                            var data1 = await submitdata(text1);
                            print(data1);
                            /*setState(() {
                      _dataModel = data1;
                    });*/
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => nextpage(
                                        summ: data1.toString(),
                                      )),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "SUMMARIZE",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: SelectableText(
                    scannedText,
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            )),
      )),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
