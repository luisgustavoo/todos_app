import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:todos_app/data/services/shared_preferences_service.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/utils/result.dart';

@injectable
class LocalDataService {
  LocalDataService(SharedPreferencesService sharedPreferences)
    : _sharedPreferences = sharedPreferences,
      _log = Logger('LocalDataService');

  final SharedPreferencesService _sharedPreferences;
  final Logger _log;

  Future<Result<void>> saveTodo(Todo todo) async {
    try {
      // await _sharedPreferences.clear();
      // return Result.ok(null);
      final result = await find(TodoStatus.all);

      switch (result) {
        case Ok<List<Todo>>():
          return _saveTodo(todo: todo, todos: result.value);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      _log.warning('Erro ao criar todo $e');
      return Result.error(e);
    }
  }

  Future<Result<List<Todo>>> find(TodoStatus status) async {
    try {
      final result = await _sharedPreferences.getTodos();
      switch (result) {
        case Ok<String?>():
          return _find(status: status, value: result.value);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _saveTodo({
    required Todo todo,
    required List<Todo> todos,
  }) async {
    final newTodos = [...todos];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      newTodos[todoIndex] = todo;
    } else {
      newTodos.add(todo);
    }
    await _sharedPreferences.setTodos(jsonEncode(newTodos));
    return const Result.ok(null);
  }

  Future<Result<List<Todo>>> _find({
    required String? value,
    required TodoStatus status,
  }) async {
    if (value?.isEmpty ?? true) {
      return const Result.ok([]);
    }
    final todosJson = jsonDecode(value!) as List<dynamic>;
    final todosMap = List<Map<String, dynamic>>.from(todosJson);
    final todos = todosMap.map(Todo.fromJson).toList();
    final pending = todos
        .where(
          (todo) => !todo.isDone,
        )
        .toList();
    final done = todos
        .where(
          (todo) => todo.isDone,
        )
        .toList();

    return switch (status) {
      TodoStatus.pending => Result.ok(pending),
      TodoStatus.done => Result.ok(done),
      _ => Result.ok(todos),
    };
  }
}
