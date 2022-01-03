import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAPI{

  Future notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,

      ),
      iOS: IOSNotificationDetails(

      ),
    );
  }

  Future<void> sendNotification ({int id = 0, String? title, String? body, String? payload}) async{

  var notification = FlutterLocalNotificationsPlugin();

  notification.show(

  id=0,

  title,

  body,

  await notificationDetails(),

  payload: payload );

}
}