import 'package:flutter/material.dart';
import 'package:notes_app/screens/login.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/app_textfield.dart';
import 'package:notes_app/utils/colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        },
        child: const Icon(
          Icons.logout,
          color: AppColors.textColor,
        ),
      ),
      appBar: AppBar(
        title: const AppText(
          text: "Profile",
          color: AppColors.textColor,
          weight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    CircleAvatar(
                      backgroundColor: AppColors.hintTextColor,
                      radius: 60,
                      child: AppText(
                        text: "T",
                        color: AppColors.textColor,
                        size: 45,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: AppText(
                        text: "test@gmail.com",
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
                      child: const AppTextField(
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
                      child: const Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        elevation: 3,
                        child: AppTextField(
                          hide: false,
                          radius: 10,
                          hintText: "Email",
                          labelText: "Email",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
