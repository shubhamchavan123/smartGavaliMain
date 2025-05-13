import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivityStreamController = StreamController<ConnectivityResult>();

  ConnectivityService() {
    // Listen for connectivity changes and add to stream
    Connectivity().onConnectivityChanged.listen(
      (event) {
        _connectivityStreamController.add(event.last);
      },
    );
  }

  // Expose the stream
  Stream<ConnectivityResult> get connectivityStream => _connectivityStreamController.stream;

  // Dispose the stream controller
  void dispose() {
    _connectivityStreamController.close();
  }
}
