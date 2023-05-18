import 'package:flutter/material.dart';

snackBar(BuildContext context, String content, Color? color, [Icon? tail]) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        tail ?? Container()
      ],
    ),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
    padding: const EdgeInsets.all(16),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar).close;
}
