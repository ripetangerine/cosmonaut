import 'package:timezone/timezone.dart';

class DateTimeUtil {
  // 기본 타임존을 Asia/Seoul로 지정
  static String timezone = 'Asia/Seoul';
  
  // 현지 시간을 한국시간으로 변환할때 사용
  static final korTimeZone = getLocation('Asia/Seoul');
}


extension DateTimeExtension on DateTime {
  DateTime get localTime {
    // 3에서 구한 timezone으로 location정보를 불러온다.
    final location = getLocation(DateTimeUtil.timezone);
    final localTimeZone =
        TZDateTime(location, year, month, day, hour, minute, second);
        
    // 한국시간만큼 빼기
    final utc = subtract(
      Duration(milliseconds: DateTimeUtil.korTimeZone.currentTimeZone.offset),
    );
    // local timezone의 offset만큼 더해주었다.
    final localTime = utc.add(localTimeZone.timeZoneOffset);
    
    return localTime;
  }
}