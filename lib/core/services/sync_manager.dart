import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

typedef PendingProcessor = Future<void> Function();

class SyncManager {
  SyncManager._internal({
    Connectivity? connectivity,
    Duration retryDelay = const Duration(seconds: 60),
  })  : _connectivity = connectivity ?? Connectivity(),
        retryDelay = retryDelay;

  static final SyncManager instance = SyncManager._internal();

  factory SyncManager() => instance;

  final Connectivity _connectivity;
  final Duration retryDelay;

  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _processing = false;
  bool _started = false;

  final List<PendingProcessor> processors = [];

  void start() {
    if (_started) return;
    _started = true;

    _sub = _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        _triggerProcess();
      }
    });

    _triggerProcess();
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _started = false;
  }

  void addProcessor(PendingProcessor p) {
    if (processors.contains(p)) return;
    processors.add(p);
  }

  Future<void> _triggerProcess() async {
    if (_processing) return;
    _processing = true;
    try {
      final result = await _connectivity.checkConnectivity();
      if (!result.contains(ConnectivityResult.wifi) &&
          !result.contains(ConnectivityResult.mobile)) return;

      for (final p in List<PendingProcessor>.from(processors)) {
        try {
          await p();
        } catch (e, st) {
          print("Sync processor failed: $e\n$st");
        }
      }
    } finally {
      _processing = false;
    }
  }

  Future<void> processOnce() => _triggerProcess();
}