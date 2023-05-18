import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/strings.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, required this.isNoInternetError})
      : super(key: key);
  final bool isNoInternetError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            isNoInternetError
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'YOU ARE OFFLINE',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'SOMETHING WENT\nWRONG',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
          ],
        ),
      ),
    ));
  }
}
