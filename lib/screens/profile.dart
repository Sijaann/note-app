import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/logic/auth/auth.dart';
import 'package:notes_app/screens/login.dart';
import 'package:notes_app/utils/app_button.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/app_textfield.dart';
import 'package:notes_app/utils/colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final Auth auth = Auth();

  final User? user = FirebaseAuth.instance.currentUser;
  bool signedIn = false;

  void checkUserData() {
    if (user != null) {
      signedIn = true;
    }
  }

  void getUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        nameController.text = value.data()!['name'];
        emailController.text = value.data()!['email'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserData();

    if (signedIn == true) {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (signedIn == true)
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                auth.logout(context: context);
              },
              child: const Icon(
                Icons.logout,
                color: AppColors.textColor,
              ),
            )
          : FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: const Icon(
                Icons.login,
                color: AppColors.textColor,
              ),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AppText(
          text: "Profile",
          color: AppColors.textColor,
          weight: FontWeight.w500,
        ),
      ),
      body: (signedIn == true)
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.hintTextColor,
                            radius: 60,
                            child: AppText(
                              text: nameController.text.substring(0, 1),
                              color: AppColors.textColor,
                              size: 45,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: AppText(
                              text: emailController.text,
                              color: AppColors.textColor,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: AppText(
                        text: "User Details",
                        color: AppColors.textColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                          child: const Icon(Icons.person),
                        ),
                        Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          elevation: 3,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.78,
                            child: AppTextField(
                              controller: nameController,
                              hide: false,
                              radius: 10,
                              hintText: "Name",
                              labelText: "Name",
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Icon(Icons.email),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              elevation: 3,
                              child: AppTextField(
                                controller: emailController,
                                hide: false,
                                radius: 10,
                                hintText: "Email",
                                labelText: "Email",
                                readOnly: true,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: AppText(
                text: "Login to View Profile",
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
              ),
            ),
    );
    // : Scaffold(
    //     appBar: AppBar(
    //       automaticallyImplyLeading: false,
    //       title: const AppText(
    //         text: "Profile",
    //         color: AppColors.textColor,
    //         weight: FontWeight.w500,
    //       ),
    //     ),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const AppText(
    //             text: "Login to View Profile",
    //             color: AppColors.primaryColor,
    //             weight: FontWeight.w500,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 20),
    //             child: AppButton(
    //               onTap: () {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) => const Login(),
    //                   ),
    //                 );
    //               },
    //               color: AppColors.primaryColor,
    //               height: 40,
    //               radius: 10,
    //               child: const AppText(
    //                 text: "Login",
    //                 color: AppColors.textColor,
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   );
  }
}
