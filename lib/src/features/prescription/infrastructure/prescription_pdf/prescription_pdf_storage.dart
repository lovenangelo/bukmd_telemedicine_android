import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bukmd_telemedicine/src/features/prescription/infrastructure/prescription_pdf/prescription_pdf_respository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PrescriptionPdfStorage implements PrescriptionPdfRepository {
  final _storageRef = FirebaseStorage.instance.ref();

  @override
  Future<String?> getPdf(
      {required String userId, required String prescriptionId}) async {
    String location = '/prescriptions/patients/$userId/$prescriptionId';
    // log(userId);
    // log(prescriptionId);
    // log(location);
    // log('/prescriptions/patients/NlDme2wHEPYz0BnYhu1kWEOh52j1/NlDme2wHEPYz0BnYhu1kWEOh52j109-23-22');
    try {
      final url = await _storageRef.child(location).getDownloadURL();
      return url;
    } on FirebaseException {
      return null;
    }
  }

  @override
  Future<String?> getTempPDF() async {
    try {
      final url = await _storageRef
          .child('prescriptions/temp/temp-prescription')
          .getDownloadURL();
      return url;
    } on FirebaseException {
      return null;
    }
  }

  @override
  Future<Uint8List?> getDefaultPDF() async {
    final storageRef = FirebaseStorage.instance.ref();
    final pdfRef = storageRef.child("defaults/prescription-slip.pdf");
    try {
      final Uint8List? data = await pdfRef.getData();
      return data;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  @override
  Future<void> createAndUploadPDF({
    required String name,
    required String age,
    required String sex,
    required String address,
    required String prescriptionDescription,
    required ByteData imageSignature,
  }) async {
    //Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(imageSignature.buffer.asUint8List());

    final pdfTemplate = await getDefaultPDF();
    //Create a new PDF document
    PdfDocument document = PdfDocument(inputBytes: pdfTemplate);
    // final width = document.pageSettings.width;

    final height = document.pageSettings.height;

    //Get the existing PDF page.
    final PdfPage page = document.pages[0];

    // add name
    page.graphics.drawString(name, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTRB(117, 180, 0, 0));

    // add age
    page.graphics.drawString(age, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTRB(390, 180, 0, 0));

    // add sex
    page.graphics.drawString(sex, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTRB(458, 180, 0, 0));

    // add address
    page.graphics.drawString(
        address, PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTRB(125, 193, 0, 0));

    // add date
    page.graphics.drawString(
      DateFormat('MM/dd/yyyy').format(DateTime.now()),
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: const Rect.fromLTRB(393, 193, 0, 0),
    );

    //Add the content to the document
    page.graphics.drawString(
      prescriptionDescription,
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTRB(100, height * 0.35, 0, 0),
    );

    // add doctor signature
    page.graphics.drawImage(image, const Rect.fromLTRB(300, 550, 0, 0));

    //Save the document
    List<int> bytes = await document.save();

    //Dispose the document
    document.dispose();

    await FirebaseStorage.instance
        .ref('prescriptions/temp/temp-prescription')
        .putData(Uint8List.fromList(bytes));
  }

  @override
  Future<void> saveToFirebaseStorage(String id, DateTime date) async {
    try {
      final tempPdf = _storageRef.child('prescriptions/temp/temp-prescription');
      final Uint8List? data = await tempPdf.getData();
      PdfDocument document = PdfDocument(inputBytes: data);
      List<int> bytes = await document.save();
      document.dispose();

      final displayPhotosRef = _storageRef.child(
          "prescriptions/patients/$id/${id + DateFormat('MM-dd-yyyy').format(date)}");
      await displayPhotosRef.putData(Uint8List.fromList(bytes));
      log('uploaded');
    } on FirebaseException catch (e) {
      print(e.toString());
      null;
    }
  }
}
