import 'package:flutter/material.dart';
import 'Persistence/local_store.dart';

class AppState extends ChangeNotifier {
  int counter = 0;

  Future<int> readCounter() async {
    return LocalStore.getInstance().readCounter();
  }

  void writeCounter(int counter) {
    LocalStore.getInstance().writeCounter(counter);
  }
}