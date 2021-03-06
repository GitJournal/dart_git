import 'package:dart_git/config.dart';
import 'package:dart_git/storage/config_storage.dart';
import 'package:dart_git/utils/result.dart';

class ConfigStorageExceptionCatcher implements ConfigStorage {
  final ConfigStorage _;

  ConfigStorageExceptionCatcher({required ConfigStorage storage}) : _ = storage;

  @override
  Future<Result<Config>> readConfig() => catchAll(() => _.readConfig());

  @override
  Future<Result<bool>> exists() => catchAll(() => _.exists());

  @override
  Future<Result<void>> writeConfig(Config config) =>
      catchAll(() => _.writeConfig(config));
}
