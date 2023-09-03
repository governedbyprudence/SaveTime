import 'package:logger/logger.dart';

class CustomLogger {
  static void debug(Object a){
    Logger().d(a);
  }
  static void error(Object a){
    Logger().e(a);
  }
}