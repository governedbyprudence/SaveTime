import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService{
    static Future<void> isAllowed()async{
      bool val = await AwesomeNotifications().isNotificationAllowed();
      if(val==false){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    }
    static Future<void> createScheduledNotification(DateTime dateTime,String message)async{
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: dateTime.millisecondsSinceEpoch.remainder(32),
              channelKey: "basic_channel",
              title: message
          ),
          schedule: NotificationCalendar.fromDate(date: dateTime)
      );
    }
}