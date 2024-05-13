

import 'dart:ui';

class SubjectColor{
  static const Color BIOLOGY = Color(0xFFC3E2C2);
  static const Color CHEMISTRY = Color(0xFFCFE5FD);
  static const Color PHYSICS = Color(0xFFF6F7C4);
  static const Color AGRICULTURE = Color(0xFFD096EF);
  static const Color PAPER_WRITING = Color(0xFFE7C8B2);

  static const Color BIOLOGY_DARK = Color(0xFF6C9263);
  static const Color CHEMISTRY_DARK = Color(0xFF6C9263);
  static const Color PHYSICS_DARK = Color(0xFF6C9263);
  static const Color AGRICULTURE_DARK = Color(0xFF6C9263);

  static const Color BIOLOGY_BORDER = Color(0xFF6C9263);
  static const Color CHEMISTRY_BORDER = Color(0xFF4E7DB1);
  static const Color PHYSICS_BORDER = Color(0xFF969738);
  static const Color AGRICULTURE_BORDER = Color(0xFF8248A0);

  static getPrimaryColor(String subjectName){
    switch(subjectName){
      case "biology":
        return BIOLOGY;
      case "chemistry":
        return CHEMISTRY;
      case "physics":
        return PHYSICS;
      case "agricultural":
        return AGRICULTURE;
      default:
        return BIOLOGY;
    }
  }

  static getDarkColor(String subjectName){
    switch(subjectName){
      case "biology":
        return BIOLOGY_DARK;
      case "chemistry":
        return CHEMISTRY_DARK;
      case "physics":
        return PHYSICS_DARK;
      case "agricultural":
        return AGRICULTURE_DARK;
      default:
        return BIOLOGY_DARK;
    }
  }

  static getBorderColor(String subjectName){
    switch(subjectName){
      case "biology":
        return BIOLOGY_BORDER;
      case "chemistry":
        return CHEMISTRY_BORDER;
      case "physics":
        return PHYSICS_BORDER;
      case "agricultural":
        return AGRICULTURE_BORDER;
      default:
        return BIOLOGY_BORDER;
    }
  }
}