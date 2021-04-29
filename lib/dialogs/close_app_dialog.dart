import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CloseAppDialog {
  static Future<bool?> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do you want to close the app?'),
          actions: [
            TextButton(
              child: const Text('NO'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('YES'),
              onPressed: SystemNavigator.pop,
            ),
          ],
        );
      },
    );
  }
}
