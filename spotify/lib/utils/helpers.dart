import 'package:flutter/material.dart';

Duration parseDuration(String s) {
  final parts = s.split(':');
  if (parts.length == 2) {
    return Duration(
      minutes: int.tryParse(parts[0]) ?? 0,
      seconds: int.tryParse(parts[1]) ?? 0,
    );
  }
  return Duration.zero;
}

Color parseColor(String hex) {
  try {
    return Color(int.parse(hex));
  } catch (_) {
    return const Color(0xFF282828);
  }
}