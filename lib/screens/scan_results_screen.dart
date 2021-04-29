import 'package:barcode_scanner_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class ScanResultsScreen extends StatefulWidget {
  @override
  _ScanResultsScreenState createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  List<String>? codes;
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    codes = (await PrefsService.instance).savedScannedCodes;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan results'),
      ),
      body: codes == null
          ? const SizedBox()
          : codes!.isEmpty
              ? const Center(
                  child: Text(
                    'No results',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: codes!.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Text(
                            '${i + 1}.',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(codes![i]),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                ),
    );
  }
}
