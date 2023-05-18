import 'dart:typed_data';

abstract class PrescriptionPdfRepository {
  Future<void> saveToFirebaseStorage(String id, DateTime date);
  Future<Uint8List?> getDefaultPDF();
  Future getPdf({required String userId, required String prescriptionId});
  Future<void> createAndUploadPDF({
    required String name,
    required String age,
    required String sex,
    required String address,
    required String prescriptionDescription,
    required ByteData imageSignature,
  });
  Future<String?> getTempPDF();
}
