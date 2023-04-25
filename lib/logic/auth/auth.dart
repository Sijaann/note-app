import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/login.dart';
import 'package:notes_app/screens/page_nav.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/snachbar.dart';

class Auth {
  void register({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      String uId = userCredential.user!.uid;

      await firestore.collection('users').doc(uId).set({
        'userId': uId,
        'name': name,
        'email': email,
      }).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavPage(),
          ),
        );
        showSnackBar(
          context: context,
          text: "SignUp Successful",
          textColor: AppColors.textColor,
          backgroundColor: Colors.green,
        );
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }

  void login(
      {required FirebaseAuth auth,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      getCurrentUser(context: context);
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context: context,
        text: e.toString(),
        textColor: AppColors.textColor,
        backgroundColor: Colors.red,
      );
    }
  }

  void getCurrentUser({required BuildContext context}) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then(
        (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NavPage(),
            ),
          );

          showSnackBar(
            context: context,
            text: "SignUp Successful",
            textColor: AppColors.textColor,
            backgroundColor: Colors.green,
          );
        },
      );
    }
  }

  void logout({required BuildContext context}) async {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
      showSnackBar(
        context: context,
        text: "User Logged Out",
        textColor: AppColors.textColor,
        backgroundColor: Colors.green,
      );
    });
  }
}
