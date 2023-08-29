import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStore {
  static final LocalStore _instance = LocalStore.internal();

  static LocalStore internal() {
    // Perform any initialization logic here.
    return LocalStore();
  }

  // Getter to access Singleton instance
  static LocalStore getInstance() {
    return _instance ;
  }

  // Added for persistence
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    }
    catch (e) {
      // Assume no data found, indicating no previous access
      return 0;
    }
  }
}