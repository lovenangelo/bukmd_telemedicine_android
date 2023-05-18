import 'package:bukmd_telemedicine/src/constants/strings.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/appointment_history_screen.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/medical_record_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/theme.dart';
import '../../authentication/controllers/user_auth_service_controller.dart';

final _authServiceController = UserAuthServiceController();

class ProfileScreenDrawer extends StatelessWidget {
  const ProfileScreenDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                child: Center(
                  child: SvgPicture.asset(
                    Strings.logo,
                    width: 160.0,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'Personal Information',
                ),
                onTap: () =>
                    Navigator.pushNamed(context, '/updateuserinformation'),
              ),
              ListTile(
                title: const Text(
                  'Appointment History',
                ),
                leading: const Icon(
                  Icons.history,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const AppointmentHistory();
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.medical_information),
                title: const Text(
                  'Medical Record',
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const MedicalRecordScreen();
                })),
              ),
              ListTile(
                title: const Text(
                  'Sign Out',
                ),
                leading: const Icon(
                  Icons.logout,
                ),
                onTap: () {
                  Scaffold.of(context).closeDrawer();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Do you want to sign out?'),
                        backgroundColor: primaryColor,
                        titleTextStyle: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                              try {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                imageCache.clear();
                                imageCache.clearLiveImages();
                                await DefaultCacheManager().emptyCache();
                                await _authServiceController.userSignOut();
                              } on FirebaseAuthException catch (e) {
                                print(e.toString());
                              }
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
