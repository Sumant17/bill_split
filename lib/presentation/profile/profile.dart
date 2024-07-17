import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_app/components/login_auth/login_page.dart';
import 'package:my_app/presentation/profile/profile_details.dart';
import 'package:my_app/widgets/my_background_color.dart';
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
    return MyBackgroundColor(
      child: Drawer(
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
                    color: const Color.fromARGB(255, 159, 210, 234),
                    elevation: 4,
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
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final name =
                                    snapshot.data?['name'] ?? 'No Name';
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
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileDetails()));
                            },
                            child: const Text(
                              'View Profile',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xff000080),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Sure'),
                    content: const Text('Are you sure you want to Logout?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(color: Color(0xff000080)),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Login()));
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Color(0xff000080)),
                          )),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 280,
            ),
            Image.asset(
              'assets/Splitter.png',
              height: 130,
              width: 130,
            )
          ],
        ),
      ),
    );
  }
}
