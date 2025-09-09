import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_app/utils/result.dart';

@injectable
class SharedPreferencesService {
  SharedPreferencesService(SharedPreferences sharedPreferences)
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @visibleForTesting
  static const kTodosCollectionKey = '__todos_collection_key__';
  final _log = Logger('SharedPreferencesService');

  Future<Result<String?>> getTodos() async {
    try {
      _log.finer('Buscando as tarefas no SharedPreferences');
      return Result.ok(_sharedPreferences.getString(kTodosCollectionKey));
    } on Exception catch (e) {
      _log.warning('Erro ao buscar todos no SharedPreferences', e);
      return Result.error(e);
    }
  }

  Future<Result<void>> setTodos(String value) async {
    try {
      _log.finer('Adicionando tarefas no SharedPreferences');
      await _sharedPreferences.setString(kTodosCollectionKey, value);
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Erro ao adicionar tarefas no SharedPreferences', e);
      return Result.error(e);
    }
  }

  Future<Result<void>> clear() async {
    try {
      _log.finer('Limpando tarefas no SharedPreferences');
      await _sharedPreferences.clear();
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning('Erro ao limpar tarefas no SharedPreferences', e);
      return Result.error(e);
    }
  }
}
