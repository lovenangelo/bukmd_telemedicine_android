import 'dart:io';

import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/snackbar.dart';
import '../../../authentication/service/firebase_auth_service.dart';

import '../../application/photo_url.dart';
import '../../infrastructure/services/display_photo_cloud_storage_service.dart';

class ImagePickerDialog extends ConsumerStatefulWidget {
  const ImagePickerDialog({super.key, required this.getImagePath});
  final Function(File? file, bool hasUploaded, String? url) getImagePath;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImagePickerDialogState();
}

class _ImagePickerDialogState extends ConsumerState<ImagePickerDialog> {
  final _auth = FirebaseAuthService();
  final _displayPhotoCloudStorage = DisplayPhotoCloudStorageService();
  final _storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _auth.currentUser?.photoURL != null
          ? const Text('Update photo')
          : const Text('Upload photo'),
      content: const Text('File size should not exceed 2MB'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getImageFromFile(ImageSource.camera, 'Camera'),
            getImageFromFile(ImageSource.gallery, 'Gallery'),
            _auth.currentUser?.photoURL != null
                ? TextButton(
                    onPressed: () async {
                      try {
                        if (!mounted) return;
                        Navigator.pop(context);
                        await _auth.currentUser!.updatePhotoURL(null);
                        await _displayPhotoCloudStorage
                            .deletePhoto()
                            .whenComplete(() async {
                          // ref
                          //     .read(photoUrlNotifierProvider.notifier)
                          //     .updateUrl(null);
                          // ref.refresh(updatePhotoUrlProvider);
                          await DefaultCacheManager().emptyCache();
                        });
                        await _auth.reloadUser();

                        widget.getImagePath(null, false, null);
                      } on FirebaseException catch (e) {
                        print(e.message.toString());
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ))
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget getImageFromFile(ImageSource imgSrc, String title) => TextButton(
        onPressed: () async {
          final imagePicker = ImagePicker();
          final image = await imagePicker.pickImage(source: imgSrc);
          if (image == null) return;
          final imageSize = await image.length();

          if (imageSize > 2e+6) {
            if (!mounted) return;
            snackBar(
              context,
              'File size is too big',
              Colors.red,
            );
            Navigator.pop(context);
            return;
          }
          File file = File(image.path);

          if (!mounted) return;
          Navigator.pop(context);

          try {
            EasyLoading.show(status: 'Uploading photo');
            final displayPhotosRef = _storageRef
                .child("images/users_display_photo/${_auth.currentUser!.uid}");
            final url = await updatePhotoUrl();
            widget.getImagePath(file, true, url);
            await displayPhotosRef.putFile(file);
            EasyLoading.dismiss();
          } on FirebaseException catch (e) {
            print(e.message.toString());
          }
        },
        child: Text(title),
      );

  Future<String?> updatePhotoUrl() async {
    final url = await _displayPhotoCloudStorage.getUserPhotoDownloadURL();
    // ref.read(photoUrlNotifierProvider.notifier).updateUrl(url);
    // ref.refresh(updatePhotoUrlProvider);
    await _auth.currentUser!.updatePhotoURL(url);
    await _auth.reloadUser();
    return url;
  }
}
