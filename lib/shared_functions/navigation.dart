import 'package:flutter/material.dart';
import 'package:nottacafe/src/screens/cuisines/cuisines.dart';

void replaceAndPush(BuildContext context, Widget navigateTo) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => navigateTo,
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 200),
    ),
  );
}

dynamic justPush(BuildContext context, Widget navigateTo) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => navigateTo,
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 200),
    ),
  );
}