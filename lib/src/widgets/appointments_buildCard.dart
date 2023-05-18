import 'package:flutter/material.dart';

import '../theme/theme.dart';

Widget buildCard(int index) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.blue[300]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Name: Loven Angelo G. Dayola',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Date: 24/02/2022',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Time: 7:30 AM',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text(
                'Concern',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: primaryColor),
              ),
              Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. '),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
