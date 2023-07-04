import 'package:contact_app/Services/db_helper.dart';
import 'package:contact_app/View/Home_Screen.dart';
import 'package:contact_app/View/Widgets/common_textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool loading = false;
  final box = GetStorage();

  Future registration() async {
    try {
      setState(() {
        loading = true;
      });
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      print('EMAIL ${credential.user!.email}');
      print('UID ${credential.user!.uid}');
      await box.write('userId', credential.user!.uid);
      DatabaseHelper.insertData(
          "${nameController.text}", "${credential.user!.uid}");
      Get.to(HomeScreen(userId: credential.user!.uid,));
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      print('ERROR ${e.code}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.message}")));
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    DatabaseHelper.createDB();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            children: [
              SizedBox(height: height * 0.050),
              Image.asset("assets/images/register.png"),
              SizedBox(height: height * 0.040),
              CommonTextFormField(
                controller: nameController,
                lable: 'Enter name',
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: height * 0.030),
              CommonTextFormField(
                controller: emailController,
                lable: 'Enter email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: height * 0.030),
              CommonTextFormField(
                controller: passwordController,
                lable: 'Enter password',
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: height * 0.060,
              ),
              loading
                  ? CircularProgressIndicator()
                  : MaterialButton(
                      color: Colors.blue,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      minWidth: double.infinity,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        registration();
                      },
                    ),
              SizedBox(height: height * 0.030),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  "),
                  GestureDetector(
                      onTap: () async {
                        await Get.to(const LoginScreen());
                        Get.to(const HomeScreen());
                      },
                      child: const Text("Sign In")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
