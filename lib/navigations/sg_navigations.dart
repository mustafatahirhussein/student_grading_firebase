import 'package:flutter/material.dart';

class SgNavigation {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  pushAndRemove(Widget route) {
    navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => route), (route) => false);
  }

  push(Widget route) {
    navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => route));
  }

  pop() {
    navigatorKey.currentState!.pop();
  }
}
