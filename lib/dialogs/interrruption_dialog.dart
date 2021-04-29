import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InterruptionDialog {
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Scanning was interrupted'),
          actions: [
            TextButton(
              child: const Text('Resume'),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }
}
