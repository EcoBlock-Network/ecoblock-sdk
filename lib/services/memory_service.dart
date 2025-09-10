import 'package:flutter/foundation.dart';

class MemoryService {
  final Map<String, Object?> _store = {};

  T? read<T>(String key) {
    final v = _store[key];
    if (v == null) return null;
    return v as T;
  }

  void write<T>(String key, T value) {
    _store[key] = value;
    if (kDebugMode) debugPrint('[MemoryService] write $key -> $value');
  }

  void remove(String key) {
    _store.remove(key);
  }

  void clear() {
    _store.clear();
  }
}

final memoryService = MemoryService();
