import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  String _answerText = '';
  Function()? _buttonPressed = () {};

  Answer({required Function()? pressed, required String text}) {
    this._answerText = text;
    this._buttonPressed = pressed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
        ),
        onPressed: _buttonPressed,
        child: Text(
          _answerText,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
