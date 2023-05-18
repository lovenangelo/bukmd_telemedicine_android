import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../theme/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Container(), backgroundColor: Colors.white24),
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SvgPicture.asset(
              'lib/src/assets/logo/bukmd-logo.svg',
              width: 200.0,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 128, vertical: 24),
            child: LinearProgressIndicator(
              backgroundColor: primaryColor,
            ),
          ),
        ]),
      ),
    );
  }
}
