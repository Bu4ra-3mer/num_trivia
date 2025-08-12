import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected; // mandatory
}

class NetworkInfoImplenemation implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImplenemation(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

