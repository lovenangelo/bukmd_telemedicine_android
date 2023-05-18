import 'dart:async';

import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/appointment_record_screen.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/appointment_requests_screen.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/dashboard_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/application/bot_nav_wrapper_controller.dart';
import '../shared/presentation/doctor_error_page.dart';
import '../theme/theme.dart';
import '../widgets/snackbar.dart';

class DoctorBottomNavBarWrapper extends ConsumerStatefulWidget {
  const DoctorBottomNavBarWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DoctorBottomNavBarWrapperState();
}

class _DoctorBottomNavBarWrapperState
    extends ConsumerState<DoctorBottomNavBarWrapper> {
  ConnectivityResult? _connectivityResult;
  late StreamSubscription connection;

  @override
  initState() {
    // The order here is important
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if ((result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) &&
          _connectivityResult != null) {
        snackBar(
            context,
            'Internet connection restored',
            primaryColor,
            const Icon(
              Icons.wifi,
              color: Colors.white,
            ));
      }
      setState(() {
        _connectivityResult = result;
      });
      if (_connectivityResult == ConnectivityResult.none ||
          result == ConnectivityResult.none) {
        snackBar(
            context,
            'Internet connection is lost',
            primaryColor,
            const Icon(
              Icons.signal_cellular_connected_no_internet_0_bar,
              color: Colors.white,
            ));
      }
    });

    super.initState();
  }

  @override
  dispose() {
    connection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      (_connectivityResult == ConnectivityResult.none)
          ? const DoctorErrorPage(isNoInternetError: true)
          : const DoctorDashboardScreen(),
      const AppointmentRecordScreen(),
      (_connectivityResult == null ||
              _connectivityResult == ConnectivityResult.none)
          ? const DoctorErrorPage(isNoInternetError: true)
          : const AppointmentRequestScreen(),
    ];

    int currentIndex = ref.watch(botNavBarWrapperIndexProvider);

    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) => ref
                .read(botNavBarWrapperIndexProvider.notifier)
                .setNewCurrent(index),
            elevation: 8,
            currentIndex: currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder), label: 'Records'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_task), label: 'Requests'),
            ],
            selectedItemColor: primaryColor));
  }
}
