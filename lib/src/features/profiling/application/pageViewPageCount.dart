import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageViewPageCountProvider =
    StateNotifierProvider<PageViewPageCount, double>((ref) {
  return PageViewPageCount();
});

class PageViewPageCount extends StateNotifier<double> {
  PageViewPageCount() : super(0);

  updatePageCount(double count) => state = count;
}
