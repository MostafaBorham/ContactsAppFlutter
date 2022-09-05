import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallerNumber {
  static call(String url) async {
    await FlutterPhoneDirectCaller.callNumber(url);
  }}