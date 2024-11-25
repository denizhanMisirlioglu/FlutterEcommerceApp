import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFFCC00); // Sarı renk (Sepete Ekle butonu için)
  static const Color primaryDark = Color(0xFFFF9900); // Turuncu (Şimdi Al butonu için)

  // Secondary Colors
  static const Color secondary = Color(0xFF187BCD); // AppBar mavi tonu
  static const Color secondaryDark = Color(0xFF0E4C7E); // Daha koyu bir mavi (gölge veya vurgu için)

  // Neutral Colors
  static const Color background = Color(0xFFF8F8F8); // Açık gri arka plan
  static const Color cardBackground = Color(0xFFFFFFFF); // Beyaz arka plan ürün kartları için
  static const Color divider = Color(0xFFE0E0E0); // Hafif gri bölücüler için
  static const Color shadow = Color(0xFFB0B0B0); // Gölge için daha yumuşak bir gri

  // Text Colors
  static const Color textPrimary = Color(0xFF333333); // Koyu gri (Ürün başlığı gibi ana metinler için)
  static const Color textSecondary = Color(0xFF666666); // Açık gri (Ürün açıklamaları gibi)
  static const Color textHighlight = Color(0xFFFF5733); // Fiyatlar gibi vurgu metinler için hafif turuncu

  // Error & Warnings
  static const Color error = Color(0xFFD93025); // Kırmızı (Hata mesajları için)
  static const Color warning = Color(0xFFFFA41C); // Uyarı turuncusu
}
