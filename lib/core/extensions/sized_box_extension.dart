import 'package:flutter/material.dart';

extension SizeBoxExtension on num {
  SizedBox vs() {
    return SizedBox(height: toDouble());
  }

  SizedBox hs() {
    return SizedBox(width: toDouble());
  }
}

