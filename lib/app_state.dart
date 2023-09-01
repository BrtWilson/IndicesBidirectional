import 'package:flutter/material.dart';
import 'Persistence/local_store.dart';

class AppState extends ChangeNotifier {
  late Map<String, String> index;
  late Map<String, String> reverse;

  Future<Map<String,String>> initialize() async {
    await _setIndices();
    return index;
  }

  Future<int> readCounter() async {
    return LocalStore.getInstance().readCounter();
  }

  void writeCounter(int counter) async {
    LocalStore.getInstance().writeCounter(counter);
  }

  Future<Map<String,String>> readIndex() async {
    return index;
  }

  void overwriteIdx(Map<String,String> idx) async {
    index = idx;
    _updateRemote();
  }

  Future<int> _setIndices() async {
    index = await LocalStore.getInstance().readIndex();
    reverse = index.map((k, v) => MapEntry(v, k));
    return 0;
  }

  bool addToIndex(String key, String val) {
    if (index.containsKey(key)) return false;
    index[key] = val;
    _updateRemote();
    return true;
  }

  void _updateRemote() {
    LocalStore.getInstance().writeIndex(index);
  }
}