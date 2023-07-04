// ignore_for_file: use_build_context_synchronously
import 'package:contact_app/Services/db_helper.dart';
import 'package:contact_app/View/Auth_Screen/register_screen.dart';
import 'package:contact_app/View/Home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;
  final box = GetStorage();
  Future login() async {
    try {
      setState(() {
        loading = true;
      });
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      await box.write('userId', credential.user!.uid);
      DatabaseHelper.insertData(
          "${credential.user!.displayName}", "${credential.user!.uid}");
      print('EMAIL ${credential.user!.email}');
      print('UID ${credential.user!.uid}');
      Get.to(HomeScreen(userId: credential.user!.uid));
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR${e.code}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            children: [
              SizedBox(height: height * 0.060),
              Image.asset("assets/images/login.png"),
              SizedBox(height: height * 0.040),
              TextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(height: height * 0.040),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(height: height * 0.060),
              loading
                  ? const CircularProgressIndicator()
                  : MaterialButton(
                color: Colors.blue,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)),
                minWidth: double.infinity,
                onPressed: () {
                  login();
                },
                child: const Text('Sign In',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: height * 0.030),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  "),
                  GestureDetector(
                      onTap: () {
                        Get.to(const RegisterScreen());
                      },
                      child: const Text("Sign Up")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
