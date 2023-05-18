import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DisplayPhotoCloudStorageService {
  final _storageRef = FirebaseStorage.instance.ref();
  final _currentUser = FirebaseAuth.instance.currentUser!.uid;

  Future uploadPhoto(File file) async {
    try {
      final displayPhotosRef =
          _storageRef.child("images/users_display_photo/$_currentUser");
      return await displayPhotosRef.putFile(file);
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }

  Future<String?> getUserPhotoDownloadURL() async {
    try {
      final url = await _storageRef
          .child("images/users_display_photo/$_currentUser")
          .getDownloadURL();
      return url;
    } on FirebaseException {
      return null;
    }
  }

  Future<String?> getPatientPhotoDownloadURL(String id) async {
    try {
      final url = await _storageRef
          .child("images/users_display_photo/$id")
          .getDownloadURL();
      return url;
    } on FirebaseException {
      return null;
    }
  }

  deletePhoto() async {
    await _storageRef
        .child("images/users_display_photo/$_currentUser")
        .delete();
  }

  Future<String?> getDefaultPhotoURL() async {
    try {
      final url =
          await _storageRef.child("deafults/user_icon.png").getDownloadURL();
      return url;
    } on FirebaseException {
      return null;
    }
  }
}
