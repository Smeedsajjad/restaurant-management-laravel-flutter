import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Example breakpoints
  // bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  // bool get isDesktop => screenWidth >= 1024;
}
