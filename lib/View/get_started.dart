import 'package:contact_app/Services/db_helper.dart';
import 'package:contact_app/View/Auth_Screen/login_screen.dart';
import 'package:contact_app/View/Auth_Screen/register_screen.dart';
import 'package:contact_app/View/Home_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  final box = GetStorage();
  Future google() async {
    GoogleSignInAccount? account = await googleSignIn.signIn();

    GoogleSignInAuthentication authentication = await account!.authentication;

    OAuthCredential credentials = GoogleAuthProvider.credential(
      accessToken:authentication.accessToken,
      idToken: authentication.idToken
    );

    UserCredential credential = await auth.signInWithCredential(credentials);
    print('EMAIL ${credential.user!.email}');
    print('UID${credential.user!.uid}');
    print('NAME${credential.user!.displayName}');
    print('PHOTO${credential.user!.photoURL}');
    await box.write('userId', credential.user!.uid);
    DatabaseHelper.insertData("${credential.user!.displayName}", "${credential.user!.uid}");
    Get.to(HomeScreen(userId: credential.user!.uid,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/get-started.png",
            ),
            const Text("Let’s get started!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 40),
            MaterialButton(
              color: Colors.white,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              minWidth: double.infinity,
              onPressed: () {
                google();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/google.png", scale: 3),
                  const SizedBox(width: 10),
                  const Text('Continue with Google'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              color: Colors.white,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              minWidth: double.infinity,
              onPressed: () {
                Get.to(const RegisterScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/email.png", scale: 3),
                  const SizedBox(width: 10),
                  const Text('Continue with Email'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            MaterialButton(
              color: Colors.blue,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)),
              minWidth: double.infinity,
              onPressed: () {
                Get.to(const LoginScreen());
              },
              child: const Text('Sign In with password',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
