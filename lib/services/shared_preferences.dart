import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  final List<String> savedScannedCodes;
  PrefsService._(this.savedScannedCodes);

  static const _SAVED_CODES_KEY = 'savedCodes';

  static final _pendingFutures = <Future>[];

  static Future<PrefsService> get instance async {
    if (_instance == null) {
      final sharedPrefs = await SharedPreferences.getInstance();
      _instance = PrefsService._(
        sharedPrefs.getStringList(_SAVED_CODES_KEY) ?? <String>[],
      );
    }

    return _instance!;
  }

  void saveCode(String code) {
    if (savedScannedCodes.length == 10) savedScannedCodes.removeAt(0);
    savedScannedCodes.add(code);
    _updatePrefs();
  }

  Future<void> removeLastCode() async {
    savedScannedCodes.removeLast();
    _updatePrefs();
  }

  void _updatePrefs() async {
    await Future.wait(_pendingFutures);

    late Future future;
    future = SharedPreferences.getInstance()
        .then((sharedPrefs) =>
            sharedPrefs.setStringList(_SAVED_CODES_KEY, savedScannedCodes))
        .then((_) => _pendingFutures.remove(future));
    _pendingFutures.add(future);
  }

  static PrefsService? _instance;
}
