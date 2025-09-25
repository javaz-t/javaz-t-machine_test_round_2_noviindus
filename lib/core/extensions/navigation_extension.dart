
import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}
Future<void> pushToScreen(Widget screen, BuildContext context) {
  return context.navigator.push(
    MaterialPageRoute(builder: (context) => screen),
  );
}

void pushReplacementToScreen(Widget screen, BuildContext context) {
  context.navigator.pushReplacement(
    MaterialPageRoute(builder: (context) => screen),
  );
}

void pushAndRemoveUntilScreen(Widget screen, BuildContext context) {
  context.navigator.pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => screen),
        (route) => false,
  );
}

