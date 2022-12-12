import 'package:flutter/material.dart';
import 'package:lab2/answer.dart';

import 'question.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;

  var questions = [
    {
      'question': 'Select shirt type',
      'answer': [
        'T-shirt',
        'Long sleeves',
        'Sleeveless',
        'Turtleneck',
      ]
    },
    {
      'question': 'Select sock type',
      'answer': [
        'Normal',
        'Long',
        'Short',
        'None',
      ]
    },
    {
      'question': 'Select shoe type',
      'answer': [
        'Dress',
        'Running',
        'Sneakers',
        'Flip flops',
        'Crocs',
        'Sandals',
      ]
    },
    {
      'question': 'Select pants type',
      'answer': [
        'Pantaloons',
        'Trousers',
        'None',
      ]
    },
  ];

  void _buttonPressed() {
    setState(() {
      _questionIndex += 1;
    });
    print('tapped ' + _questionIndex.toString());
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
            Question(text: questions[_questionIndex]['question'].toString()),
            ...(questions[_questionIndex]['answer'] as List<String>)
                .map((answer) {
              return Answer(pressed: _buttonPressed, text: answer);
            }),
          ]),
        ));
  }
}
