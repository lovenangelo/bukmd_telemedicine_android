import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';

class TitleContainer extends StatelessWidget {
  const TitleContainer({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey[30], fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
