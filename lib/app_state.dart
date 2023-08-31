import 'package:flutter/material.dart';
import 'Persistence/local_store.dart';

class AppState extends ChangeNotifier {
  late Map<String, String> index;
  late Map<String, String> reverse;

  Future<int> initialize() async {
    _setIndices();
    return 0;
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

  void _setIndices() async {
    index = await LocalStore.getInstance().readIndex();
    reverse = index.map((k, v) => MapEntry(v, k));
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