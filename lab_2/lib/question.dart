import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Question extends StatelessWidget {
  String _questionText = '';
  Question({required String text}) {
    this._questionText = text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
      child: Text(
        _questionText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 35,
          color: Colors.blue,
        ),
      ),
    );
  }
}
