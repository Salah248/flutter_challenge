import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBarNotifier extends StateNotifier<int> {
  NavBarNotifier(super.state);

  void setPageIndex(int index) {
    state = index;
  }
}

final navBarProvider = StateNotifierProvider<NavBarNotifier, int>((_) {
  return NavBarNotifier(0);
});
