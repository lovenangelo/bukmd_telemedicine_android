import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/strings.dart';
import '../../features/authentication/controllers/user_auth_service_controller.dart';

final _authServiceController = UserAuthServiceController();

class DoctorErrorPage extends StatelessWidget {
  const DoctorErrorPage({Key? key, required this.isNoInternetError})
      : super(key: key);
  final bool isNoInternetError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: primaryColor,
          title: const Text('BukMD'),
          actions: [signOutButton(context)],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isNoInternetError
                    ? SvgPicture.asset(
                        Strings.imgErrorPage,
                        width: 220,
                      )
                    : SvgPicture.asset(
                        Strings.imgFailure,
                        width: 220,
                      ),
                const SizedBox(height: 16),
                const Text(
                  'YOU ARE OFFLINE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36),
                ),
              ],
            ),
          ),
        ));
  }

  signOutButton(BuildContext context) => IconButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Do you want to sign out?'),
              backgroundColor: primaryColor,
              titleTextStyle:
                  const TextStyle(fontSize: 16.0, color: Colors.white),
              titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();

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
      icon: const Icon(Icons.exit_to_app));
}
