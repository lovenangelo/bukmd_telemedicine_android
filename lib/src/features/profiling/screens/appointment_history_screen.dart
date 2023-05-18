import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/appointment_record_lv.dart';
import '../../authentication/controllers/user_auth_service_controller.dart';
import '../infrastructure/controller_firestore_appointment.dart';

final _authServiceController = UserAuthServiceController();

class AppointmentHistory extends ConsumerStatefulWidget {
  const AppointmentHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentHistoryState();
}

class _AppointmentHistoryState extends ConsumerState<AppointmentHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white));
        }),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Appointment Record',
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                ref.invalidate(studentAppointmentRecordProvider(
                    _authServiceController.getUserUid()!));
              },
              child: AppointmentRecordListView(
                uid: _authServiceController.getUserUid()!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
