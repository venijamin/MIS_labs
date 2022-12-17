import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab_3/widgets/auth/utils.dart';

import '../../main.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignIn({super.key, required this.onClickedSignUp});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
          ),
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(label: Text('Email')),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(label: Text('Password')),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: signIn,
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.lock_open_rounded),
            label: Text(
              'Sign in',
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Text(
              'Forgot password?',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ForgotPassword(),
            )),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                text: 'No account? ',
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Sign up',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.tertiary))
                ]),
          )
        ],
      ));

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
