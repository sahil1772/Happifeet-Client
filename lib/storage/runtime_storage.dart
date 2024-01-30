import 'package:happifeet_client_app/model/Theme/ClientTheme.dart';

class RuntimeStorage {
  static final RuntimeStorage instance = RuntimeStorage._internal();

  factory RuntimeStorage() {
    return instance;
  }
  RuntimeStorage._internal();

  ClientTheme? clientTheme;
}