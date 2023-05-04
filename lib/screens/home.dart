import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/logic/auth/auth.dart';
import 'package:notes_app/screens/groupDocuments/groupHome.dart';
import 'package:notes_app/screens/login.dart';
import 'package:notes_app/screens/personalDocument/personal_documents.dart';
import 'package:notes_app/screens/starred/starred.dart';
import 'package:notes_app/utils/app_button.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/colors.dart';
import 'package:notes_app/utils/snachbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Auth auth = Auth();
  String name = "";
  String email = "";

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
        name = value.data()!['name'];
        email = value.data()!['email'];
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
    signedIn;
    return (signedIn == true)
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const AppText(
                text: "Notes App",
                weight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            drawer: Drawer(
              elevation: 0,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: [
                        UserAccountsDrawerHeader(
                          // <-- SEE HERE
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          accountName: AppText(
                            text: name,
                            size: 18,
                            color: AppColors.textColor,
                            weight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                          accountEmail: AppText(
                            text: email,
                            size: 13,
                            color: AppColors.textColor,
                            weight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor:
                                AppColors.backgroundColor.withOpacity(0.8),
                            radius: 25,
                            child: AppText(
                              text: name.substring(0, 1),
                              color: AppColors.textColor,
                              size: 40,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PersonalDocuments(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                          title: const AppText(
                            text: "Personal Documents",
                            color: AppColors.textColor,
                            size: 18,
                            weight: FontWeight.w500,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StarredNotes(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          title: const AppText(
                            text: "Starred Documents",
                            color: AppColors.textColor,
                            size: 18,
                            weight: FontWeight.w500,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GroupHome(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.group,
                            color: AppColors.primaryColor,
                          ),
                          title: const AppText(
                            text: "Group Documents",
                            color: AppColors.textColor,
                            size: 18,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onTap: () {
                            auth.logout(context: context);
                          },
                          color: Colors.red,
                          height: 40,
                          radius: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.logout),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: AppText(
                                  text: "LogOut",
                                  weight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 178,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.hintTextColor.withOpacity(0.2),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        dense: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalDocuments(),
                            ),
                          );
                        },
                        leading: const Icon(
                          Icons.person_rounded,
                          color: Colors.green,
                        ),
                        title: const AppText(
                          text: "Personal Documents",
                          color: AppColors.textColor,
                          weight: FontWeight.w500,
                          size: 18,
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: AppColors.hintTextColor,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        dense: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StarredNotes(),
                            ),
                          );
                        },
                        leading: const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        title: const AppText(
                          text: "Starred",
                          color: AppColors.textColor,
                          weight: FontWeight.w500,
                          size: 18,
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: AppColors.hintTextColor,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        dense: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GroupHome(),
                            ),
                          );
                        },
                        leading: const Icon(
                          Icons.group,
                          color: Colors.blue,
                        ),
                        title: const AppText(
                          text: "Group Documents",
                          color: AppColors.textColor,
                          weight: FontWeight.w500,
                          size: 18,
                        ),
                      ),
                      // const Divider(
                      //   indent: 15,
                      //   endIndent: 15,
                      //   thickness: 0.5,
                      //   color: AppColors.hintTextColor,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const AppText(
                text: "Notes App",
                weight: FontWeight.w500,
                color: AppColors.textColor,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 178,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.hintTextColor.withOpacity(0.2),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        dense: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalDocuments(),
                            ),
                          );
                        },
                        leading: const Icon(
                          Icons.person_rounded,
                          color: Colors.green,
                        ),
                        title: const AppText(
                          text: "Personal Documents",
                          color: AppColors.textColor,
                          weight: FontWeight.w500,
                          size: 18,
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: AppColors.hintTextColor,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        dense: true,
                        onTap: () {
                          showSnackBar(
                            context: context,
                            text: "Please Login to view stared documents",
                            textColor: AppColors.textColor,
                            backgroundColor: Colors.amber,
                          );
                        },
                        leading: const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        title: const AppText(
                          text: "Starred",
                          color: AppColors.textColor,
                          weight: FontWeight.w500,
                          size: 18,
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                        thickness: 0.5,
                        color: AppColors.hintTextColor,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        dense: true,
                        onTap: () {
                          showSnackBar(
                            context: context,
                            text: "Please Login to view group documents",
                            textColor: AppColors.textColor,
                            backgroundColor: Colors.amber,
                          );
                        },
                        leading: const Icon(
                          Icons.group,
                          color: Colors.blue,
                        ),
                        title: const AppText(
                          text: "Group Documents",
                          color: AppColors.textColor,
                          weight: FontWeight.w500,
                          size: 18,
                        ),
                      ),
                      // const Divider(
                      //   indent: 15,
                      //   endIndent: 15,
                      //   thickness: 0.5,
                      //   color: AppColors.hintTextColor,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
