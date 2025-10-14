import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectionCheckComponent extends StatefulWidget {
  final Widget child;
  const ConnectionCheckComponent({
    super.key,
    required this.child  
  });

  @override
  State<ConnectionCheckComponent> createState() => _ConnectionCheckComponentState();
}

class _ConnectionCheckComponentState extends State<ConnectionCheckComponent> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.mobile];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus[0] == ConnectivityResult.none
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.signal_wifi_connected_no_internet_4, size: 60),
              SizedBox(height: 30),
              Text(
                "Tidak ada koneksi internet",
                style: TextStyle(
                  fontSize: 20
                ),
              )
            ],
          ),
        )
      : widget.child;
  }
}