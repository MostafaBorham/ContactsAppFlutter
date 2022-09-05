import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog{
  static Future<void> showAlertDialog(context,String title,String msg, Null Function() yesFunction) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: Colors.grey.shade700,
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.bottomCenter,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    msg,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                primary: Colors.white60
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: yesFunction,
              style: TextButton.styleFrom(
                  primary: Colors.white60
              ),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}