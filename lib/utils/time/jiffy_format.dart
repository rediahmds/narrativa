import 'package:jiffy/jiffy.dart';

class JiffyFormat {
  static String relativeTime(String date) {
    final jiffyDate = Jiffy.parse(date);
    return jiffyDate.fromNow();
  }
}
