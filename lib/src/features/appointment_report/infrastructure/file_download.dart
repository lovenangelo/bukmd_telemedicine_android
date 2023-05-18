import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PrescriptionFileDownload {
  static Future downloadFile(
      {required String userId, required String prescriptionId}) async {
    final date =
        DateFormat('MM-dd-yy').format(DateTime.now()).toString().trim();
    log(date);
    try {
      final storagePermission = await [Permission.storage].request();

      if (storagePermission[Permission.storage] == PermissionStatus.granted) {
        if (Platform.isAndroid) {
          final bytes =
              await getBytePDF(userId: userId, prescriptionId: prescriptionId);
          Directory dir = Directory('/storage/emulated/0/Download');
          log(dir.path);

          final file = File('${dir.path}/bukmd-e-prescription-$date.pdf');

          await file.writeAsBytes(
            bytes!,
          );
        }
      }
    } catch (e) {
      print('error');
    }
  }
}

Future<Uint8List?> getBytePDF(
    {required String userId, required String prescriptionId}) async {
  final storageRef = FirebaseStorage.instance.ref();
  log("prescriptions/patients/$userId/$prescriptionId");
  final pdfRef =
      storageRef.child("prescriptions/patients/$userId/$prescriptionId");
  try {
    final Uint8List? data = await pdfRef.getData();
    return data;
  } on FirebaseException catch (e) {
    return null;
  }
}
