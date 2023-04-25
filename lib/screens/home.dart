import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/logic/auth/auth.dart';
import 'package:notes_app/screens/personalDocument/personal_documents.dart';
import 'package:notes_app/screens/starred/starred.dart';
import 'package:notes_app/utils/app_button.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.primaryColor,
      //   onPressed: () {},
      //   child: const Icon(
      //     Icons.add,
      //     color: AppColors.textColor,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const AppText(
          text: "Notes App",
          weight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.textColor,
                  // size: 44, // Changing Drawer Icon Size
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        elevation: 0,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const UserAccountsDrawerHeader(
                    // <-- SEE HERE
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                    accountName: Text(
                      "Test User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      "test@gmail.com",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    currentAccountPicture: FlutterLogo(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      dense: true,
                      title: AppText(
                        text: "Notifications",
                        color: AppColors.textColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    title: const AppText(
                      text: "Invite Garne ko Email",
                      color: AppColors.textColor,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    title: const AppText(
                      text: "Invite Garne ko Email",
                      color: AppColors.textColor,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
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
                    color: AppColors.primaryColor,
                    height: 40,
                    radius: 10,
                    child: const AppText(
                      text: "LogOut",
                      color: AppColors.textColor,
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
                  onTap: () {},
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
