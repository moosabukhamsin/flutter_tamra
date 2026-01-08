import 'package:flutter/material.dart';

/// ألوان التطبيق الأساسية - للحفاظ على هوية التصميم
class AppColors {
  // اللون الأساسي للتطبيق (البني/الأحمر الداكن)
  static const Color primary = Color(0XFF7C3425);
  
  // ألوان النصوص
  static const Color textPrimary = Color(0XFF3D3D3D);
  static const Color textSecondary = Color(0XFF707070);
  static const Color textLight = Color(0XFF888888);
  static const Color textDark = Color(0XFF2E2E2E);
  static const Color textMedium = Color(0XFF5B5B5B);
  static const Color textPlaceholder = Color(0XFF909090);
  static const Color textGray = Color(0XFF6A6A6A);
  static const Color textBlue = Color(0XFF6C7B8A);
  
  // ألوان الأيقونات
  static const Color iconColor = Color(0XFF575757);
  
  // ألوان الخلفية
  static const Color background = Colors.white;
  static const Color backgroundLight = Color(0XFFF4F6F9);
  static const Color backgroundGray = Color(0XFFeeeeee);
  
  // ألوان الحدود
  static const Color borderLight = Color(0XFFD1D1D1);
  static const Color borderGray = Color(0XFFE0E0E0);
  static const Color borderWhite = Color(0XFFE5E5E5);
  
  // ألوان الأزرار
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0XFF888888);
  static const Color buttonAccent = Color(0Xff112E5B);
  
  // ألوان خاصة
  static const Color accentBlue = Color(0XFF1EB7CD);
  
  // منع إنشاء instance من الكلاس
  AppColors._();
}
