import 'package:bukmd_telemedicine/firebase_options.dart';
import 'package:bukmd_telemedicine/src/routes/routes.dart';
import 'package:bukmd_telemedicine/src/shared/domain/custom_animation.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: BukMDApp()));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class BukMDApp extends StatefulWidget {
  const BukMDApp({Key? key}) : super(key: key);

  @override
  State<BukMDApp> createState() => _BukMDAppState();
}

class _BukMDAppState extends State<BukMDApp> {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BukMD Application',
        theme: appTheme,
        routes: appRoutes,
        initialRoute: '/authwrapper',
        builder: EasyLoading.init(
          builder: (context, child) {
            return ResponsiveWrapper.builder(child,
                maxWidth: 1200,
                minWidth: 480,
                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(800, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ],
                background: Container(color: const Color(0xFFF5F5F5)));
          },
        ));
  }
}
