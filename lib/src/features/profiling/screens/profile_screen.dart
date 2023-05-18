import 'package:bukmd_telemedicine/src/features/profiling/screens/upcoming_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme.dart';

import '../../../widgets/divider.dart';
import '../../../widgets/profile_user_image.dart';
import '../../video_call/call.dart';
import 'profile_drawer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      drawer: const ProfileScreenDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: Colors.white));
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        surfaceTintColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text('BukMD Patient',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 82),
              decoration: BoxDecoration(
                border: Border(
                  top: borderSide(),
                  left: borderSide(),
                  right: borderSide(),
                  bottom: const BorderSide(width: 3.0, color: Colors.white),
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Text(
                      'SCHEDULED APPOINTMENT',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    SizedBox(height: 16),
                    SizedBox(height: 8, child: horizontalDivider),
                    UpcomingAppointment(),
                  ],
                ),
              ),
            ),
            const UserProfileImage(),
          ],
        ),
      ),
    );
  }

  BorderSide borderSide() => const BorderSide(width: 3.0, color: Colors.white);
}
