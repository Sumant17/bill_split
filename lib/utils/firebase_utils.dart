import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/models/groups_model.dart';
import 'package:my_app/models/my_user_model.dart';

class FirebaseUtils {
  //a function to upload profile pic to firebase storage
  static Future<bool> uploadFileForUser(XFile file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = file.path.split('/').last;
      final timeStamp = DateTime.now().microsecondsSinceEpoch;
      final uploadRef = storageRef.child('/uploads/$timeStamp-$fileName');
      await uploadRef.putFile(File(file.path));
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> uploaduserdetails(MyUserModel user) async {
    try {
      final usercollection = FirebaseFirestore.instance.collection('users');

      await usercollection.add(user.toJson());

      // user.forEach((element) async {
      //   await usercollection
      //       .add(element)
      //       .then((v) => print("Data added"))
      //       .catchError((error) => print("Failed to add user: $error"));
      // });
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> uploadgroupdetails(GroupsModel group) async {
    try {
      final groupcollection = FirebaseFirestore.instance.collection('groups');

      await groupcollection.add(group.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }
}
