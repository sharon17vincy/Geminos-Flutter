import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationHelper {

  Future<bool> sendNotification(String token, context,) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return false;
    }

    final response =await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          //TODO add server key here
          'Authorization': 'key=',
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'title': 'Test Notification',
            'body': 'Welcome to Geminos group of companies',
            'sound': 'true'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "/topics/all"
        })).whenComplete(() {
//      print('sendOrderCollected(): message sent');
    }).catchError((e) {
      print(' error: $e');
    });



    return true;
  }

}
