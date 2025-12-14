import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) => 
      DateFormat('dd.MM.yyyy', 'ru').format(date);
  
  static String formatMonth(DateTime date) => 
      DateFormat('LLLL yyyy', 'ru').format(date);
  
  static String formatTime(DateTime date) => 
      DateFormat('HH:mm', 'ru').format(date);
  
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
  
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

// Alias for backward compatibility
typedef DateUtils = AppDateUtils;

