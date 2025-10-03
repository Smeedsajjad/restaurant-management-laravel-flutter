import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

abstract class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = TextStyle(
    fontSize: AppSizes.font2xl,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = TextStyle(
    fontSize: AppSizes.fontXl,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle body = TextStyle(
    fontSize: AppSizes.fontMd,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = TextStyle(
    fontSize: AppSizes.fontSm,
    color: AppColors.textSecondary,
  );

  // Button style helper
  static TextStyle button = TextStyle(
    fontSize: AppSizes.fontMd,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}
