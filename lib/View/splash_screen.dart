import 'package:contact_app/View/Home_Screen.dart';
import 'package:contact_app/View/get_started.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  Future getData() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return box.read('userId') == null
                  ? const GetStarted()
                  : const HomeScreen();
            } else {
              return Center(
                child: Lottie.network(
                    "https://assets5.lottiefiles.com/packages/lf20_GofK09iPAE.json"),
              );
            }
          }),
    );
  }
}
