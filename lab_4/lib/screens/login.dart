import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/auth/user_auth_page.dart';
import '../widgets/utils.dart';
import 'home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Get the document if it exists,
                // else create a new document
                String? uid = FirebaseAuth.instance.currentUser?.uid;
                uid = FirebaseAuth.instance.currentUser?.uid;

                // If there is no document it creates one in the database for the account
                checkExist(uid ?? '').then((value) {
                  value
                      ? null
                      : events.doc(uid).set(
                          {'events': {}},
                        );
                });

                return MyHomePage();
              } else {
                return UserAuthPage();
              }
            }));
  }
}
