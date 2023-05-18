import 'dart:async';

import 'package:bukmd_telemedicine/src/features/appointment_scheduling/presentation/appointment_screen.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/auth_view_models.dart';
import 'package:bukmd_telemedicine/src/features/authentication/controllers/user_auth_service_controller.dart';
import 'package:bukmd_telemedicine/src/features/news_health_updates/screens/news_health_screen.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/profile_screen.dart';
import 'package:bukmd_telemedicine/src/shared/application/bot_nav_wrapper_controller.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavBarWrapper extends ConsumerStatefulWidget {
  const BottomNavBarWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavBarWrapperState();
}

class _BottomNavBarWrapperState extends ConsumerState<BottomNavBarWrapper> {
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
        snackBar(context, 'Internet connection restored', primaryColor,
            const Icon(Icons.wifi, color: Colors.white,));
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
            const Icon(Icons.signal_cellular_connected_no_internet_0_bar,  color: Colors.white,));
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
      const ProfileScreen(),
      (_connectivityResult == null ||
              _connectivityResult == ConnectivityResult.none)
          ? const ErrorPage(isNoInternetError: true)
          : const AppointmentScreen(),
      (_connectivityResult == null ||
              _connectivityResult == ConnectivityResult.none)
          ? const ErrorPage(isNoInternetError: true)
          : const NewsHealthScreen()
    ];
    final authServiceController = UserAuthServiceController();

    bool isUserVerified =
        ref.watch(userVerificationProvider(authServiceController));

    int currentIndex = ref.watch(botNavBarWrapperIndexProvider);
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: isUserVerified
          ? BottomNavigationBar(
              onTap: (index) => ref
                  .read(botNavBarWrapperIndexProvider.notifier)
                  .setNewCurrent(index),
              elevation: 8,
              currentIndex: currentIndex,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: 'Profile'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Request'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.newspaper), label: 'News Health')
              ],
              selectedItemColor: primaryColor)
          : null,
    );
  }
}
