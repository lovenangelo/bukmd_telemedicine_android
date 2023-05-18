import 'package:flutter/widgets.dart';

removeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
