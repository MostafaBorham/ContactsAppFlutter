import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast{
  static void showToast({required String msg,required Color background,required Color textColor}){
     Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: background,
        textColor: textColor,
        fontSize: 15.0
    );
  }
}