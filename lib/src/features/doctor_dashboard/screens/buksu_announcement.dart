import 'package:bukmd_telemedicine/src/shared/domain/buksu_announcements/buksu_announcements_model.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../shared/infrastructure/service/buksu_announcements/buksu_announcements_firestore.dart';
import '../application/buksi_announcements/action_state.dart';
import '../application/buksi_announcements/announcement_form.dart';
import '../application/buksu_announcement_provider.dart';

final _formKey = GlobalKey<FormState>();
final _buksuFirestore = BuksuAnnouncementsFirestore();

class UpdateAnnouncementPage extends ConsumerWidget {
  const UpdateAnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcement = ref.watch(announcementFormProvider);
    final action = ref.watch(actionProvider);
    final actionRead = ref.read(actionProvider.notifier).actionRead;
    final actionCreate = ref.read(actionProvider.notifier).actionCreate;
    final actionUpdate = ref.read(actionProvider.notifier).actionUpdate;

    final whatTextController = TextEditingController();
    final whereTextController = TextEditingController();
    final moreInfoTextController = TextEditingController();

    TextEditingController datePickerController = TextEditingController();

    Future pickDateRange() async {
      DateTime? datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (datePick == null) return;
      datePickerController.text = datePick.toString().substring(0, 10).trim();
      ref
          .read(announcementFormProvider.notifier)
          .setDate(datePickerController.text);
    }

    currentAnnouncement(BuksuAnnouncements data) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Here you can create, update or delete the existing announcement.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'POSTED ANNOUNCEMENT',
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                      horizontalDivider,
                      const SizedBox(height: 16),
                      Text(
                        'Title: ${data.title}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${data.date}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${data.location}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'More info: ${data.description}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                              onPressed: () async {
                                EasyLoading.show(status: "deleting...");
                                await _buksuFirestore.deleteAnnouncement();
                                EasyLoading.dismiss();
                                ref.invalidate(buksuAnnouncementProvider);
                                ref
                                    .read(actionProvider.notifier)
                                    .setStateRead();
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              label: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              )),
                          ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(actionProvider.notifier)
                                    .setStateUpdate();
                              },
                              icon:
                                  const Icon(Icons.update, color: Colors.white),
                              label: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

    createAnnouncement(BuksuAnnouncements? data) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        '${data == null ? 'Create' : 'Update'} Announcement',
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        cursorColor: primaryColor,
                        initialValue: data?.title ?? '',
                        decoration: const InputDecoration(
                          labelText: 'What?',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          ref
                              .read(announcementFormProvider.notifier)
                              .setTitle(value);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        cursorColor: primaryColor,
                        initialValue: data?.location ?? '',
                        decoration: const InputDecoration(
                          labelText: 'Where?',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          ref
                              .read(announcementFormProvider.notifier)
                              .setLocation(value);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        cursorColor: primaryColor,
                        controller: datePickerController,
                        decoration: const InputDecoration(
                          labelText: 'When?',
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          return null;
                        },
                        onTap: () async => await pickDateRange(),
                        onChanged: (value) async => await pickDateRange(),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                          cursorColor: primaryColor,
                          initialValue: data?.description ?? '',
                          decoration: const InputDecoration(
                            hintText: 'Additional information...',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be empty';
                            }
                            if (value.length > 200) {
                              return 'Keep it short';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            ref
                                .read(announcementFormProvider.notifier)
                                .setDescription(value);
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ref.read(actionProvider.notifier).setStateRead();
                          },
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: Colors.white),
                          )),
                      ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                EasyLoading.show(status: 'posting...');
                                await _buksuFirestore
                                    .createAnnouncement(announcement);
                                EasyLoading.dismiss();
                                ref.invalidate(buksuAnnouncementProvider);
                                ref
                                    .read(actionProvider.notifier)
                                    .setStateRead();
                              } on FirebaseException catch (e) {
                                print(e.toString());
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'POST',
                            style: TextStyle(color: Colors.white),
                          )),
                    ])
              ]),
            ),
          ),
        );

    return ref.watch(buksuAnnouncementProvider).when(
        data: (data) {
          datePickerController.text = data?.date ?? '';
          whatTextController.text = data?.title ?? '';
          whereTextController.text = data?.location ?? '';
          moreInfoTextController.text = data?.description ?? '';

          if (action == actionRead && data != null) {
            return Scaffold(
              appBar: appBar,
              body: currentAnnouncement(data),
            );
          }

          if (action == actionCreate) {
            return Scaffold(
              appBar: appBar,
              body: createAnnouncement(null),
            );
          }

          if (action == actionUpdate) {
            return Scaffold(
              appBar: appBar,
              body: createAnnouncement(data),
            );
          }

          return Scaffold(
              appBar: appBar,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.announcement_rounded,
                      size: 120,
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: 260.0,
                      child: const Text(
                        'Here you can create, update or delete the existing announcement.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                      onPressed: () =>
                          ref.read(actionProvider.notifier).setStateCreate(),
                      icon: const Icon(
                        Icons.create,
                        color: Colors.white,
                      ),
                      label: const Text('CREATE',
                          style: TextStyle(color: Colors.white))),
                ],
              ));
        },
        error: (e, st) => const ErrorPage(isNoInternetError: false),
        loading: () => Scaffold(appBar: appBar, body: const LoadingScreen()));
  }
}

final appBar = AppBar(
  leading: Builder(builder: (context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.white));
  }),
  iconTheme: const IconThemeData(color: Colors.white),
  centerTitle: true,
  title: const Text('Edit Announcement', style: TextStyle(color: Colors.white)),
  backgroundColor: primaryColor,
);
