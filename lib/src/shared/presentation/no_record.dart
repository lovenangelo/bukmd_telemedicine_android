import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget noRecord([String? status]) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: SvgPicture.asset(
              'lib/src/assets/images/no-data.svg',
              width: 220.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            status ?? 'No record data',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
