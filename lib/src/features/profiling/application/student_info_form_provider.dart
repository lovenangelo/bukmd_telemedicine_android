import 'package:bukmd_telemedicine/src/features/profiling/models/student.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentInformationFormProvider =
    StateNotifierProvider<StudentInformationFormNotifier, Student>((ref) {
  return StudentInformationFormNotifier();
});

class StudentInformationFormNotifier extends StateNotifier<Student> {
  StudentInformationFormNotifier() : super(Student());

  setAllStudentFormData(Student student) {
    setIdNumber(student.idNumber!);
    setfullName(student.fullName!);
    setBirthDate(student.birthDate!);
    setSex(student.sex!);
    setBarangay(student.barangay!);
    setCity(student.city!);
    setProvince(student.province!);
    setPhoneNumber(student.studentPhoneNumber!);
    setGuardianName(student.guardianName!);
    setGuardianPhoneNumber(student.guardianPhoneNumber!);
    setGuardianRelationship(student.guardianRelationship!);
    setWeight(student.weight!);
    setHeight(student.height!);
    setCourse(student.course!);
    setYearLevel(student.yearLevel!);
    setHasMedicalRecord(student.hasMedicalRecord!);
    setHasAppointmentRequest(student.hasAppointmentRequest!);
  }

  get name => state.fullName;

  setNameOfFather(String name) {
    state.nameOfFather = name;
  }

  setNameOfMother(String name) {
    state.nameOfMother = name;
  }

  setFatherContactNum(String number) {
    state.fatherContactNum = number;
  }

  setMotherContactNum(String number) {
    state.motherContactNum = number;
  }

  setCivilStatus(String? status) {
    state.civilStatus = status;
  }

  setLivingWith(String? livingWith) {
    state.livingWith = livingWith;
  }

  setDateOfRegistration(String date) {
    state.dateOfRegistration = date;
  }

  setIdNumber(String idNum) {
    state.idNumber = idNum;
  }

  setfullName(String fullName) {
    state.fullName = fullName;
  }

  setBirthDate(String birthDate) {
    state.birthDate = birthDate;
  }

  setSex(String sex) {
    state.sex = sex;
  }

  setBarangay(String barangay) {
    state.barangay = barangay;
  }

  setCity(String city) {
    state.city = city;
  }

  setProvince(String province) {
    state.province = province;
  }

  setPhoneNumber(String phoneNumber) {
    state.studentPhoneNumber = phoneNumber;
  }

  setGuardianName(String guardianName) {
    state.guardianName = guardianName;
  }

  setGuardianPhoneNumber(String phoneNumber) {
    state.guardianPhoneNumber = phoneNumber;
  }

  setGuardianRelationship(String relationship) {
    state.guardianRelationship = relationship;
  }

  setWeight(double weight) {
    state.weight = weight;
  }

  setHeight(double height) {
    state.height = height;
  }

  setCourse(String course) {
    state.course = course;
  }

  setYearLevel(String yl) {
    state.yearLevel = yl;
  }

  setHasMedicalRecord(bool value) {
    state.hasMedicalRecord = value;
  }

  setHasAppointmentRequest(bool value) {
    state.hasAppointmentRequest = value;
  }
}
