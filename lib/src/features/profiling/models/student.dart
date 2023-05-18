class Student {
  String? idNumber;
  String? fullName;
  String? birthDate;
  String? sex;
  String? barangay;
  String? city;
  String? province;
  String? studentPhoneNumber;
  String? guardianName;
  String? guardianPhoneNumber;
  String? guardianRelationship;
  bool? hasAppointmentRequest;
  bool? hasMedicalRecord;
  double? weight;
  double? height;
  String? course;
  String? yearLevel;
  String? civilStatus;
  String? nameOfFather;
  String? nameOfMother;
  String? motherContactNum;
  String? fatherContactNum;
  String? livingWith;
  String? dateOfRegistration;
  Student({
    this.idNumber,
    this.fullName,
    this.birthDate,
    this.sex,
    this.barangay,
    this.city,
    this.province,
    this.studentPhoneNumber,
    this.guardianName,
    this.guardianPhoneNumber,
    this.guardianRelationship,
    this.weight,
    this.height,
    this.course,
    this.yearLevel,
    this.civilStatus,
    this.nameOfFather,
    this.nameOfMother,
    this.motherContactNum,
    this.fatherContactNum,
    this.livingWith,
    this.dateOfRegistration,
    this.hasAppointmentRequest = false,
    this.hasMedicalRecord = false,
  });

  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      idNumber: json['idNumber'],
      fullName: json['fullName'],
      birthDate: json['birthDate'],
      sex: json['sex'],
      barangay: json['barangay'],
      city: json['city'],
      province: json['province'],
      studentPhoneNumber: json['studentPhoneNumber'],
      guardianName: json['guardianName'],
      guardianPhoneNumber: json['guardianPhoneNumber'],
      guardianRelationship: json['guardianRelationship'],
      hasAppointmentRequest: json['hasAppointmentRequest'],
      hasMedicalRecord: json['hasMedicalRecord'],
      weight: json['weight'],
      height: json['height'],
      course: json['course'],
      yearLevel: json['yearLevel'],
      civilStatus: json['civilStatus'],
      nameOfFather: json['nameOfFather'],
      nameOfMother: json['nameOfMother'],
      motherContactNum: json['motherContactNum'],
      fatherContactNum: json['fatherContactNum'],
      livingWith: json['livingWith'],
      dateOfRegistration: json['dateOfRegistration'],
    );
  }

  static Map<String, dynamic> toJson(Student student) {
    return {
      'idNumber': student.idNumber,
      'fullName': student.fullName,
      'birthDate': student.birthDate,
      'sex': student.sex,
      'barangay': student.barangay,
      'city': student.city,
      'province': student.province,
      'studentPhoneNumber': student.studentPhoneNumber,
      'guardianName': student.guardianName,
      'guardianPhoneNumber': student.guardianPhoneNumber,
      'guardianRelationship': student.guardianRelationship,
      'hasAppointmentRequest': student.hasAppointmentRequest,
      'hasMedicalRecord': student.hasMedicalRecord,
      'weight': student.weight,
      'height': student.height,
      'yearLevel': student.yearLevel,
      'course': student.course,
      'civilStatus': student.civilStatus,
      'nameOfFather': student.nameOfFather,
      'nameOfMother': student.nameOfMother,
      'motherContactNum': student.motherContactNum,
      'fatherContactNum': student.fatherContactNum,
      'livingWith': student.livingWith,
      'dateOfRegistration': student.dateOfRegistration,
    };
  }
}
