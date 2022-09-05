import 'dart:io';

import 'package:flutter_sms/flutter_sms.dart';

class SmsSender{
  static sendMessage({required String number,required String msg}) async {
    String _result = await sendSMS(message: msg, recipients: [number])
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}