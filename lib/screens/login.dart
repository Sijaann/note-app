import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/logic/auth/auth.dart';
import 'package:notes_app/screens/page_nav.dart';
import 'package:notes_app/screens/register.dart';
import 'package:notes_app/utils/app_button.dart';
import 'package:notes_app/utils/app_text.dart';
import 'package:notes_app/utils/app_textfield.dart';
import 'package:notes_app/utils/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Auth auth = Auth();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                      text: "Login",
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
                        hide: hidePassword,
                        radius: 10,
                        hintText: "Password",
                        labelText: "Password",
                        leadingIcon: const Icon(Icons.password),
                        iconButton: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye_rounded),
                        ),
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
                          auth.login(
                            auth: _auth,
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                            context: context,
                          );
                        }
                      },
                      color: AppColors.primaryColor,
                      height: 40,
                      radius: 10,
                      child: const AppText(
                        text: "Login",
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
                      text: "Don't have an account?",
                      color: AppColors.textColor,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      child: const AppText(
                        text: "Signup",
                        color: AppColors.primaryColor,
                        size: 15,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavPage(),
                      ),
                    );
                  },
                  child: const AppText(
                    text: "Skip",
                    color: AppColors.primaryColor,
                    size: 15,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
