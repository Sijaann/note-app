import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/logic/auth/auth.dart';
import 'package:notes_app/screens/login.dart';
import 'package:notes_app/utils/app_text.dart';

import '../utils/app_button.dart';
import '../utils/app_textfield.dart';
import '../utils/colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Auth auth = Auth();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "N",
                  style: GoogleFonts.raleway(
                    fontSize: 48,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const AppText(
                  text: "Notes App",
                  size: 22,
                  color: AppColors.primaryColor,
                  weight: FontWeight.w500,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 35, bottom: 20),
                    child: AppText(
                      text: "Signup",
                      color: AppColors.textColor,
                      size: 25,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _nameController,
                        hide: false,
                        radius: 10,
                        hintText: "Full Name",
                        labelText: "Name",
                        leadingIcon: const Icon(Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AppTextField(
                          controller: _emailController,
                          hide: false,
                          radius: 10,
                          hintText: "Email",
                          labelText: "Email",
                          leadingIcon: const Icon(Icons.email),
                        ),
                      ),
                      AppTextField(
                        controller: _passwordController,
                        hide: false,
                        radius: 10,
                        hintText: "Password",
                        labelText: "Password",
                        leadingIcon: const Icon(Icons.password),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          auth.register(
                            auth: _auth,
                            firestore: _firestore,
                            context: context,
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      color: AppColors.primaryColor,
                      height: 40,
                      radius: 10,
                      child: const AppText(
                        text: "Signup",
                        color: AppColors.textColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                      text: "Already have an account?",
                      color: AppColors.textColor,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const AppText(
                        text: "Login",
                        color: AppColors.primaryColor,
                        size: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
