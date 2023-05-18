import 'package:bukmd_telemedicine/src/features/search_students/presentation/search_students_screen.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../authentication/controllers/user_auth_service_controller.dart';

final UserAuthServiceController _authServiceController =
    UserAuthServiceController();

class DoctorAppDrawer extends StatelessWidget {
  const DoctorAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Center(
            child: SvgPicture.asset(
              'lib/src/assets/logo/bukmd-logo.svg',
              width: 160.0,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.newspaper),
          title: const Text(
            'BukSU Announcement',
          ),
          onTap: () => Navigator.pushNamed(context, '/announcement'),
        ),
        ListTile(
            leading: const Icon(Icons.people),
            title: const Text(
              'Students',
            ),
            onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const SearchStudentsScreen();
                }))),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text(
            'Sign out',
          ),
          onTap: () {
            Scaffold.of(context).closeDrawer();

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Do you want to sign out?'),
                  backgroundColor: primaryColor,
                  titleTextStyle:
                      const TextStyle(fontSize: 16.0, color: Colors.white),
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
                          await _authServiceController.userSignOut();
                        } on FirebaseAuthException catch (e) {
                          print(e.message.toString());
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
    ));
  }
}
