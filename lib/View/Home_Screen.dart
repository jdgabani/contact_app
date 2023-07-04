import 'dart:typed_data';

import 'package:contact_app/View/get_started.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.userId}) : super(key: key);
  final userId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = GetStorage();
  GoogleSignIn googleSignIn = GoogleSignIn();
  List<Contact>? contacts;
  bool loading = false;
  void getPhoneData() async {
    setState(() {
      loading = true;
    });
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print(contacts);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getPhoneData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: const Text("My Contact"),
        actions: [
          IconButton(
            onPressed: () async {
              await box.erase();
              await googleSignIn.signOut();
              Get.to(const GetStarted());
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          const SizedBox(width: 25),
        ],
      ),
      body: loading
          ? const LinearProgressIndicator()
          : ListView.builder(
        shrinkWrap: true,
        itemCount: contacts!.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          Uint8List? image = contacts![index].photo;
          String number = contacts![index].phones.isNotEmpty
              ? contacts![index].phones.first.number
              : "----";
          return ListTile(
            leading: image == null
                ? const CircleAvatar(
              child: Icon(Icons.person),
            )
                : CircleAvatar(
              backgroundImage: MemoryImage(image),
            ),
            title: Text(contacts![index].name.first),
            subtitle: Text(number),
          );
        },
      ),
    );
  }
}
