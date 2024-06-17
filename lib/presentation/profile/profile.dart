import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  Future<Map<String, String?>> _getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('myName');
    final imagepath = prefs.getString('myimagepath');
    return {'name': name, 'imagepath': imagepath};
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.amber,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              DrawerHeader(
                child: Card(
                  color: const Color.fromARGB(255, 171, 193, 203),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder<Map<String, String?>>(
                          future: _getUserProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final name = snapshot.data?['name'] ?? 'No Name';
                              final imagepath = snapshot.data?['imagepath'];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: imagepath != null &&
                                            imagepath.isNotEmpty
                                        ? FileImage(File(imagepath))
                                        : null,
                                    radius: 30,
                                    child:
                                        imagepath == null || imagepath.isEmpty
                                            ? const Icon(Icons.person)
                                            : null,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(name),
                                ],
                              );
                            }
                          },
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('View Profile'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
