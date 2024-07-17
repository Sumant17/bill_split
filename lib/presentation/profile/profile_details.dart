import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/widgets/my_background_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  Future<Map<String, String?>> fetchprofiledetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('myName');
    final imagepath = prefs.getString('myimagepath');
    final email = prefs.getString('myEmail');
    return {'name': name, 'imagepath': imagepath, 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Profile Details'),
      ),
      body: MyBackgroundColor(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            FutureBuilder<Map<String, String?>>(
              future: fetchprofiledetails(),
              builder: (contect, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error : ${snapshot.error}');
                } else {
                  final myname = snapshot.data?['name'] ?? 'No Name';
                  final myimagepath = snapshot.data?['imagepath'] ?? 'No image';
                  final myemail = snapshot.data?['email'] ?? 'No Email';

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: myimagepath.isNotEmpty
                              ? FileImage(File(myimagepath))
                              : null,
                          radius: 40,
                          child: myimagepath.isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: TextEditingController(text: myname),
                          readOnly: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: TextEditingController(text: myemail),
                          readOnly: true,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xff000080),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
