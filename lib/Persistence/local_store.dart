import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStore {
  static const bool DEBUG = true;
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

  Future<File> get _ctrFile async {
    final path = await _localPath;
    print(path.toString());
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _ctrFile;
    return file.writeAsString('$counter');
  }

  Future<int> readCounter() async {
    try {
      final file = await _ctrFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    }
    catch (e) {
      // Assume no data found, indicating no previous access
      return 0;
    }
  }

  Future<File> get _idxFile async {
    final path = await _localPath;
    return File('$path/index.txt');
  }

  Future<File> writeIndex(Map<String,String> idx) async {
    if (DEBUG) print("Add to Index - write index start.");
    final file = await _idxFile;             // QUESTION:  DOES THIS WORK IF THE FILE DOESN'T EXIST YET? -> It should. It doesn't check for it to exist.
    final String idxStr = jsonEncode(idx);
    if (DEBUG) print("Add to Index - write index end: $idxStr");
    return file.writeAsString(idxStr);
  }

  Future<Map<String,String>> readIndex() async {
    try {
      if (DEBUG) print("Read Index - start.");
      final file = await _idxFile;
      final contents = await file.readAsString();
      Map<String,String> m = mapValDynamicToString(jsonDecode(contents));
      if (DEBUG) print("Read Index - end: $contents");
      return m;
    }
    catch (e) {
      if (DEBUG) print("Read Index - catch: $e");
      // Assume no data found, indicating no previous access
      return {};
    }
  }

  Map<String,String> mapValDynamicToString(Map<String,dynamic> dmap) {
    Map<String,String> newMap = {};
    for (var en in dmap.entries) {
      if (DEBUG) print(en.value);
      newMap[en.key] = en.value as String;
    }
    return newMap;
  }
}