import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var questionIndex = 0;
  var questions = [
    'question1',
    'question2',
  ];

  void buttonPressed() {
    questionIndex++;
    print('tapped ' + questionIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hello world',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Hello world'),
          ),
          body: Column(children: [
            Text(questions[questionIndex]),
            ElevatedButton(onPressed: buttonPressed, child: Text('button1')),
            ElevatedButton(onPressed: buttonPressed, child: Text('button2')),
            ElevatedButton(onPressed: buttonPressed, child: Text('button3')),
          ]),
        ));
  }
}
