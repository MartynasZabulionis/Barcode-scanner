import 'package:barcode_scanner_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BarcodeResultDialog {
  static Future<bool?> show(BuildContext context, String code) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Text(code),
            title: const Text('Scan result:'),
            actions: [
              TextButton(
                child: const Text('Rescan'),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  (await PrefsService.instance).removeLastCode();
                },
              ),
              TextButton(
                child: const Text('Send via mail'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  final parsedUri = Uri.parse(
                    'mailto:?subject=Barcode&body=$code',
                  );
                  launch(parsedUri.toString());
                },
              ),
              TextButton(
                child: const Text('Send via another app'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Share.share(
                    code,
                    subject: 'Barcode',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
