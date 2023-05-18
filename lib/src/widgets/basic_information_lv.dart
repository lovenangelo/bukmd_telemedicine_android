import 'dart:io';

import 'package:bukmd_telemedicine/src/constants/strings.dart';
import 'package:bukmd_telemedicine/src/features/profiling/application/student_info_form_provider.dart';
import 'package:bukmd_telemedicine/src/features/profiling/application/students_firestore_controller.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';

import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/widgets/remove_screen_keyboard.dart';

import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:bukmd_telemedicine/src/widgets/title_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

import '../features/authentication/service/firebase_auth_service.dart';

import '../features/profiling/application/photo_url.dart';
import '../features/profiling/screens/widgets/image_picker_dialog.dart';
import '../theme/theme.dart';

class PersonalInformationListView extends ConsumerWidget {
  const PersonalInformationListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Scrollbar(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          separatorBuilder: (context, index) {
            return horizontalDivider;
          },
          itemCount: 1,
          itemBuilder: (context, index) {
            return const BuildCard();
          },
        ),
      ),
    );
  }
}

class BuildCard extends ConsumerStatefulWidget {
  const BuildCard({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuildCardState();
}

class _BuildCardState extends ConsumerState<BuildCard> {
  final _editInfoFormKey = GlobalKey<FormState>();
  bool isMale = false;
  bool isFemale = false;
  final _auth = FirebaseAuthService();
  final _studentsFirestore = StudentsFirestoreController();

  final studentIdNumberTextController = TextEditingController();

  final fullNameTextController = TextEditingController();

  final weightTextController = TextEditingController();
  final heightTextController = TextEditingController();
  final barangayTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final provinceTextController = TextEditingController();
  final studentPhoneNumberTextController = TextEditingController();
  final guardianNameTextController = TextEditingController();
  final guardianPhoneNumberTextController = TextEditingController();
  final guardianRelationshipTextController = TextEditingController();
  final courseTextController = TextEditingController();
  final yearLevelTextController = TextEditingController();
  final nameOfFatherTextController = TextEditingController();
  final nameOfMotherTextController = TextEditingController();
  final fatherNumberTextController = TextEditingController();
  final motherNumberTextController = TextEditingController();
  final _birthDateTextController = TextEditingController();

  late bool hasUploadedPhoto;
  @override
  void initState() {
    _studentInitData();

    super.initState();
  }

  _studentInitData() async {
    _auth.photoUrl != null ? hasUploadedPhoto = true : hasUploadedPhoto = false;

    final data = await _studentsFirestore.readStudentData();
    studentIdNumberTextController.text = data?.idNumber ?? '';

    fullNameTextController.text = data?.fullName ?? '';
    weightTextController.text = data?.weight.toString() ?? '';
    heightTextController.text = data?.height.toString() ?? '';
    barangayTextController.text = data?.barangay ?? '';
    cityTextController.text = data?.city ?? '';
    provinceTextController.text = data?.province ?? '';
    studentPhoneNumberTextController.text = data?.studentPhoneNumber ?? '';
    guardianNameTextController.text = data?.guardianName ?? '';
    guardianPhoneNumberTextController.text = data?.guardianPhoneNumber ?? '';
    guardianRelationshipTextController.text = data?.guardianRelationship ?? '';
    courseTextController.text = data?.course ?? '';
    yearLevelTextController.text = data?.yearLevel ?? '';
    nameOfFatherTextController.text = data?.nameOfFather ?? '';
    nameOfMotherTextController.text = data?.nameOfMother ?? '';
    fatherNumberTextController.text = data?.fatherContactNum ?? '';
    motherNumberTextController.text = data?.motherContactNum ?? '';
    _birthDateTextController.text = data?.birthDate != null
        ? DateFormat('MM/dd/yyyy').format(DateTime.parse(data!.birthDate!))
        : '';
    ref
        .read(studentInformationFormProvider.notifier)
        .setCivilStatus(data?.civilStatus);
    ref
        .read(studentInformationFormProvider.notifier)
        .setLivingWith(data?.livingWith);
    data?.sex == 'Male' ? isMale = true : isFemale = true;
  }

  @override
  void dispose() {
    studentIdNumberTextController.dispose();
    fullNameTextController.dispose();
    weightTextController.dispose();
    heightTextController.dispose();
    barangayTextController.dispose();
    cityTextController.dispose();
    provinceTextController.dispose();
    studentPhoneNumberTextController.dispose();
    guardianNameTextController.dispose();
    guardianPhoneNumberTextController.dispose();
    guardianRelationshipTextController.dispose();
    courseTextController.dispose();
    yearLevelTextController.dispose();
    nameOfFatherTextController.dispose();
    nameOfMotherTextController.dispose();
    fatherNumberTextController.dispose();
    motherNumberTextController.dispose();
    _birthDateTextController.dispose();
    super.dispose();
  }

  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    final formProvider = ref.watch(studentInformationFormProvider);

    final data = ref.watch(studentDataProvider);

    List<DropdownMenuItem<String>> civilStatusOptions = [
      DropdownMenuItem(
          value: 'Single',
          child: const Text(
            'Single',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setCivilStatus('Single');
          }),
      DropdownMenuItem(
          value: 'Married',
          child: const Text(
            'Married',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setCivilStatus('Married');
          }),
      DropdownMenuItem(
          value: 'Widowed',
          child: const Text(
            'Widowed',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setCivilStatus('Widowed');
          }),
      DropdownMenuItem(
          value: 'Child',
          child: const Text(
            'Child',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setCivilStatus('Child');
          })
    ];

    List<DropdownMenuItem<String>> livingWithOptions = [
      DropdownMenuItem(
          value: 'Parents/Family',
          child: const Text(
            'Parents/Family',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setLivingWith('Parents/Family');
          }),
      DropdownMenuItem(
          value: 'Guardian',
          child: const Text(
            'Guardian',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setLivingWith('Guardian');
          }),
      DropdownMenuItem(
          value: 'BukSU Dormitory',
          child: const Text(
            'BukSU Dormitory',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setLivingWith('BukSU Dormitory');
          }),
      DropdownMenuItem(
          value: 'Boarding House',
          child: const Text(
            'Boarding House',
          ),
          onTap: () {
            ref
                .read(studentInformationFormProvider.notifier)
                .setLivingWith('Boarding House');
          }),
    ];
    return data.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleContainer(title: Strings.personalInfoTitle),
              const SizedBox(height: 16),
              Form(
                key: _editInfoFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormField(
                      builder: ((field) {
                        return Row(
                          children: [
                            Material(
                              elevation: 4,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: (_auth.photoUrl != null)
                                  ? Image.network(
                                      _auth.photoUrl!,
                                      fit: BoxFit.cover,
                                      frameBuilder: ((context, child, frame,
                                          wasSynchronouslyLoaded) {
                                        return SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: child,
                                        );
                                      }),
                                      loadingBuilder:
                                          ((context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: primaryColor,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          )),
                                        );
                                      }),
                                      errorBuilder:
                                          ((context, error, stackTrace) {
                                        return Ink.image(
                                          image: const AssetImage(
                                              'lib/src/assets/defaults/default-user-image.png'),
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        );
                                      }),
                                    )
                                  : ((pickedImage == null)
                                      ? Ink.image(
                                          image: const AssetImage(
                                              'lib/src/assets/defaults/default-user-image.png'),
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          pickedImage!,
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            Container(width: 32),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '2x2 photo',
                                  style: TextStyle(fontSize: 16),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ImagePickerDialog(getImagePath:
                                              (file, hasUploaded, url) {
                                            setState(() {
                                              pickedImage = file;
                                              hasUploadedPhoto = hasUploaded;
                                              ref
                                                  .read(photoUrlNotifierProvider
                                                      .notifier)
                                                  .updateUrl(url);
                                              // ignore: unused_result
                                              ref.refresh(
                                                  updatePhotoUrlProvider);
                                            });
                                          });
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8),
                                      backgroundColor: Colors.orange[50],
                                      minimumSize: const Size(0.0, 0.0)),
                                  child: _auth.photoUrl != null
                                      ? const Text(
                                          'update photo',
                                          style: TextStyle(color: primaryColor),
                                        )
                                      : const Text(
                                          'upload photo',
                                          style: TextStyle(color: primaryColor),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                      validator: (value) {
                        if (_auth.currentUser!.photoURL == null) {
                          return 'Upload your photo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: studentIdNumberTextController,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: Strings.studentIDNumber,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: idNumberValidator,
                    ),
                    TextFormField(
                      controller: fullNameTextController,
                      keyboardType: TextInputType.name,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: Strings.formFullName,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: nameValidator,
                    ),
                    TextFormField(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: data?.birthDate != null
                                ? DateTime.parse(data!.birthDate!)
                                : DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            _birthDateTextController.text =
                                DateFormat('MM/dd/yyyy').format(date);

                            ref
                                .read(studentInformationFormProvider.notifier)
                                .setBirthDate(date.toString());
                          }
                          removeKeyboard();
                        },
                        controller: _birthDateTextController,
                        cursorColor: primaryColor,
                        decoration: const InputDecoration(
                          labelText: 'Birth Date',
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Don't leave this field empty";
                          } else {
                            return null;
                          }
                        }),
                    TextFormField(
                      controller: courseTextController,
                      onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return coursePickerDialog();
                          }),
                      keyboardType: TextInputType.none,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Course',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: stringValidator,
                    ),
                    TextFormField(
                      controller: yearLevelTextController,
                      onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return yearLevelPickerDialog();
                          }),
                      keyboardType: TextInputType.none,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Year Level',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Don't leave this field empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const TitleContainer(title: Strings.sex),
                    FormField(
                      builder: ((field) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: CheckboxListTile(
                                    activeColor: primaryColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    value: isMale,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          isMale = value;
                                          isFemale = !value;
                                        });
                                      }
                                    },
                                    title: const Text('Male'),
                                  ),
                                ),
                                Flexible(
                                  child: CheckboxListTile(
                                    activeColor: primaryColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    value: isFemale,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          isMale = !value;
                                          isFemale = value;
                                        });
                                      }
                                    },
                                    title: const Text('Female'),
                                  ),
                                ),
                              ],
                            ),
                            field.errorText != null
                                ? Text(
                                    field.errorText!,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      }),
                      validator: ((value) {
                        if (!isFemale && !isMale) {
                          return 'This field is required';
                        }
                        return null;
                      }),
                    ),
                    DropdownButtonFormField<String?>(
                      value: data?.civilStatus,
                      decoration: const InputDecoration(
                        labelText: 'Civil Status',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      items: civilStatusOptions,
                      onChanged: (_) {},
                      validator: stringValidator,
                    ),
                    DropdownButtonFormField<String?>(
                      value: data?.livingWith,
                      decoration: const InputDecoration(
                        labelText: 'Living with:',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      items: livingWithOptions,
                      onChanged: (_) {},
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Don't leave this field empty";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: weightTextController,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: weightAndHeightValidator,
                    ),
                    TextFormField(
                      controller: heightTextController,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: weightAndHeightValidator,
                    ),
                    const SizedBox(height: 16),
                    const TitleContainer(title: Strings.address),
                    TextFormField(
                      controller: barangayTextController,
                      keyboardType: TextInputType.streetAddress,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: Strings.formBarangay,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: stringValidator,
                    ),
                    TextFormField(
                      controller: cityTextController,
                      keyboardType: TextInputType.streetAddress,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: Strings.formCity,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: stringValidator,
                    ),
                    TextFormField(
                      controller: provinceTextController,
                      keyboardType: TextInputType.streetAddress,
                      cursorColor: primaryColor,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: Strings.formProvince,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: stringValidator,
                    ),
                    TextFormField(
                      controller: studentPhoneNumberTextController,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        labelText: Strings.formPhoneNumber,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: phoneNumberValidator,
                    ),
                    const SizedBox(height: 16),
                    const TitleContainer(title: Strings.emergencyCI),
                    TextFormField(
                      controller: nameOfFatherTextController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        labelText: "Father's Name",
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: nameValidator,
                    ),
                    TextFormField(
                      controller: fatherNumberTextController,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        labelText: Strings.guardianFormPhoneNumber,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: phoneNumberValidator,
                    ),
                    TextFormField(
                      controller: nameOfMotherTextController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        labelText: "Mother's Name",
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: nameValidator,
                    ),
                    TextFormField(
                      controller: motherNumberTextController,
                      keyboardType: TextInputType.number,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        labelText: Strings.guardianFormPhoneNumber,
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                      ),
                      validator: phoneNumberValidator,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      removeKeyboard();
                      if (_editInfoFormKey.currentState!.validate()) {
                        EasyLoading.show(status: 'saving');
                        if (data?.dateOfRegistration == null ||
                            data?.dateOfRegistration == 'null') {
                          ref
                              .read(studentInformationFormProvider.notifier)
                              .setDateOfRegistration(DateFormat('MM/dd/yyyy')
                                  .format(DateTime.now()));
                        } else {
                          ref
                              .read(studentInformationFormProvider.notifier)
                              .setDateOfRegistration(
                                  data!.dateOfRegistration.toString());
                        }

                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setIdNumber(studentIdNumberTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setfullName(fullNameTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setWeight(double.parse(weightTextController.text));
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setHeight(double.parse(heightTextController.text));
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setBarangay(barangayTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setCity(cityTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setProvince(provinceTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setPhoneNumber(
                                studentPhoneNumberTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setGuardianName(guardianNameTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setGuardianPhoneNumber(
                                guardianPhoneNumberTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setGuardianRelationship(
                                guardianRelationshipTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setCourse(courseTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setYearLevel(yearLevelTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setNameOfFather(nameOfFatherTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setFatherContactNum(
                                fatherNumberTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setNameOfMother(nameOfMotherTextController.text);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setMotherContactNum(
                                motherNumberTextController.text);

                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setHasMedicalRecord(
                                data?.hasMedicalRecord ?? false);

                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setHasAppointmentRequest(
                                data?.hasAppointmentRequest ?? false);
                        ref
                            .read(studentInformationFormProvider.notifier)
                            .setBirthDate(
                                data?.birthDate ?? DateTime.now().toString());
                        isMale
                            ? ref
                                .read(studentInformationFormProvider.notifier)
                                .setSex('Male')
                            : ref
                                .read(studentInformationFormProvider.notifier)
                                .setSex('Female');

                        try {
                          await _studentsFirestore.createStudentInfoData(
                              student: formProvider);
                          if (!mounted) return;
                          await _auth.updateDisplayName(ref
                              .read(studentInformationFormProvider.notifier)
                              .name);
                          if (_auth.photoUrl == null) {
                            await _auth.updatePhotoUrl(Strings.defaultPhotoImg);
                          }
                          EasyLoading.dismiss();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          snackBar(context, 'Successfully saved!', primaryColor,
                              const Icon(Icons.check, color: Colors.white));
                          final _ = ref.refresh(studentDataProvider);
                        } catch (e) {
                          EasyLoading.dismiss();

                          snackBar(
                              context,
                              'Something went wrong, try again later',
                              primaryColor,
                              const Icon(Icons.error, color: Colors.white));
                        }
                      }
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
        error: (st, e) {
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => const LoadingScreen());
  }

  coursePickerDialog() => SimpleDialog(
        // title: const Text('COURSES'),
        titleTextStyle: const TextStyle(color: Colors.black),
        children: <Widget>[
          SizedBox(
            height: 300,
            width: 200,
            child: Center(
              child: Scrollbar(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BA in Economics';

                        Navigator.pop(context);
                      },
                      title: const Text('BA in Economics',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BA in English Language';
                        Navigator.pop(context);
                      },
                      title: const Text('BA in English Language',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BA in Philosophy';
                        Navigator.pop(context);
                      },
                      title: const Text('BA in Philosophy',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BA in Social Science';
                        Navigator.pop(context);
                      },
                      title: const Text('BA in Social Science',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BA in Sociology';
                        Navigator.pop(context);
                      },
                      title: const Text('BA in Sociology',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BS in Accountancy';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Accountancy',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Automotive Technology';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Automotive Technology',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BS in Biology';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Biology',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Business Administration';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Business Administration',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Community Development';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Community Development',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Development Communication';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Development Communication',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Electronics Technology';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Electronics Technology',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Entertainment and Multimedia Computing';
                        Navigator.pop(context);
                      },
                      title: const Text(
                          'BS in Entertainment and Multimedia Computing',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Environmental Science';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Environmental Science',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BS in Food Technology';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Food Technology',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Hospitality Management';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Hospitality Management',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'BS in Information Technology';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Information Technology',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BS in Mathematics';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Mathematics',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text = 'BS in Nursing';
                        Navigator.pop(context);
                      },
                      title: const Text('BS in Nursing',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'Bachelor of Early Education';
                        Navigator.pop(context);
                      },
                      title: const Text('Bachelor of Early Education',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'Bachelor of Elementary Education';
                        Navigator.pop(context);
                      },
                      title: const Text('Bachelor of Elementary Education',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'Bachelor of Physical Education';
                        Navigator.pop(context);
                      },
                      title: const Text('Bachelor of Physical Education',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'Bachelor of Public Administration';
                        Navigator.pop(context);
                      },
                      title: const Text('Bachelor of Public Administration',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        courseTextController.text =
                            'Bachelor of Secondary Education';
                        Navigator.pop(context);
                      },
                      title: const Text('Bachelor of Secondary Education',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  yearLevelPickerDialog() => SimpleDialog(
        titleTextStyle: const TextStyle(color: Colors.black),
        children: <Widget>[
          SizedBox(
            height: 300,
            width: 200,
            child: Center(
              child: Scrollbar(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () {
                        yearLevelTextController.text = '1st year';

                        Navigator.pop(context);
                      },
                      title: const Text('1st year',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        yearLevelTextController.text = '2nd year';

                        Navigator.pop(context);
                      },
                      title: const Text('2nd year',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        yearLevelTextController.text = '3rd year';

                        Navigator.pop(context);
                      },
                      title: const Text('3rd year',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        yearLevelTextController.text = '4th year';

                        Navigator.pop(context);
                      },
                      title: const Text('4th year',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      onTap: () {
                        yearLevelTextController.text = '5th year';

                        Navigator.pop(context);
                      },
                      title: const Text('5th year',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

String? weightAndHeightValidator(String? value) {
  return value == null || value.isEmpty ? "Don't leave this field empty" : null;
}

String? stringValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Don't leave this field empty";
  } else if (!isAlpha(value.replaceAll(RegExp(r' '), 'x'))) {
    return "Invalid format";
  } else if (!isLength(value, 2, 64)) {
    return "Input is too long or too short";
  } else {
    return null;
  }
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Don't leave this field empty";
  } else if (!isLength(value, 2, 64)) {
    return "Input is too long or too short";
  } else {
    return null;
  }
}

String? idNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Don't leave this field empty";
  } else if (!isNumeric(value)) {
    return "Invalid format";
  } else if (!isLength(value, 10, 10)) {
    return "Input is too long or too short";
  } else {
    return null;
  }
}

String? phoneNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Don't leave this field empty";
  } else if (!isNumeric(value)) {
    return "Invalid format format (example - 09675432133)";
  } else if (!isLength(value, 11, 11)) {
    return "Input is too long or too short";
  } else {
    return null;
  }
}
