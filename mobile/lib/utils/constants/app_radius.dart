import 'package:flutter/material.dart';

abstract class AppRadius {
  AppRadius._();

  static const double sm = 6.0;
  static const double md = 12.0;
  static const double lg = 24.0;
  static const Radius circularSm = Radius.circular(sm);
  static const Radius circularMd = Radius.circular(md);
}
