import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/widgets/email_verification_dialog.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/basic_information_lv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/controllers/auth_view_models.dart';
import '../models/app_closer.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen(
      {Key? key, required this.title, this.canSignOut = false})
      : super(key: key);
  final String title;
  final bool canSignOut;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen>
    with AppCloser {
  final authServiceController = UserAuthServiceController();
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit BukMD?'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> _onWillPopExitApp() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit BukMD?'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => closeApp(), // <-- SEE HERE
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> _pop() async {
    return true;
  }

  final _authServiceController = UserAuthServiceController();

  @override
  Widget build(BuildContext context) {
    Future(() {
      bool isUserVerified =
          ref.read(userVerificationProvider(authServiceController));
      if (isUserVerified == false) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return WillPopScope(
                  onWillPop: _onWillPopExitApp,
                  child: const EmailVerificationDialog());
            });
      }
    });
    return WillPopScope(
      onWillPop: widget.canSignOut ? _onWillPop : _pop,
      child: Scaffold(
        appBar: AppBar(
          leading: widget.canSignOut
              ? null
              : Builder(builder: (context) {
                  return IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white));
                }),
          backgroundColor: primaryColor,
          actions: [
            widget.canSignOut
                ? IconButton(
                    onPressed: () {
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
                    icon: const Icon(Icons.logout, color: Colors.white))
                : Container()
          ],
        ),
        body: lvContainer(const PersonalInformationListView()),
      ),
    );
  }

  Widget lvContainer(Widget lvScreen) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          lvScreen,
        ],
      ),
    );
  }
}
