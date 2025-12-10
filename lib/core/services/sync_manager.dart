import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

typedef PendingProcessor = Future<void> Function();

class SyncManager {
  final Connectivity _connectivity;
  final Duration retryDelay;
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _processing = false;

  final List<PendingProcessor> processors = [];

  SyncManager({
    Connectivity? connectivity,
    this.retryDelay = const Duration(seconds: 60),
  }) : _connectivity = connectivity ?? Connectivity();

  void start() {
    _sub = _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        _triggerProcess();
      }
    });

    _triggerProcess();
  }

  void dispose() {
    _sub?.cancel();
  }

  void addProcessor(PendingProcessor p) {
    processors.add(p);
  }

  Future<void> _triggerProcess() async {
    if (_processing) return;
    _processing = true;
    try {
      var result = await _connectivity.checkConnectivity();
      if (!result.contains(ConnectivityResult.wifi) && !result.contains(ConnectivityResult.mobile)) return;

      for (final p in List<PendingProcessor>.from(processors)) {
        try {
          await p();
        } catch (e) {}
      }
    } finally {
      _processing = false;
    }
  }

  Future<void> processOnce() => _triggerProcess();
}
