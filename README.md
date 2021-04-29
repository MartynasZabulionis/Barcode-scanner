# Barcode-scanner

This app scans barcodes of Code 128 symbology.
When a barcode is captured, it is saved in local storage (using SharedPrefferences in Android and NSUserDefaults in IOS)
and a dialog is shown with three options:

  1. **Rescan** - delete the barcode and resume scanning.
  2. **Send via email** - open email app with the captured barcode value as a message body and "Barcode" as a subject.
  3. **Send via another** - open app chooser with apps that can perform sending operation.

Also, there is a button that opens a screen where one can view last 10 captured barcodes.
If the camera is active and no barcode is captured during 20 minutes, a dialog is shown with an option to leave the app.

The repository also contains ready-to-install apk file *ready_app.apk*.
