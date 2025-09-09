import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:todos_app/data/repositories/todo/todo_repository.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/utils/command.dart';
import 'package:todos_app/utils/result.dart';

enum TodoStatus { all, pending, done }

@lazySingleton
class TodoViewModel extends ChangeNotifier {
  TodoViewModel({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository {
    find = Command0(_find)..execute();
    saveTodo = Command1(_saveTodo);
    toggleStatus = Command1(_toggleStatus);
  }

  late final Command0<void> find;
  late final Command1<void, Todo> saveTodo;
  late final Command1<void, TodoStatus> toggleStatus;
  final TodoRepository _todoRepository;
  final _log = Logger('TodoViewModel');
  List<Todo> todos = [];
  TodoStatus status = TodoStatus.all;

  Future<Result<void>> _find() async {
    final result = await _todoRepository.find(status);
    switch (result) {
      case Ok():
        todos = [...result.value];
        notifyListeners();
      case Error():
        _log.warning('Erro ao listar as tarefas error: ${result.error}');
    }

    return result;
  }

  Future<Result<void>> _saveTodo(Todo todo) async {
    final result = await _todoRepository.saveTodo(todo);
    switch (result) {
      case Ok():
        await _find();
      case Error():
        _log.warning('Erro ao criar tarefa error: ${result.error}');
    }

    return result;
  }

  Future<Result<void>> _toggleStatus(TodoStatus status) async {
    this.status = status;
    return _find();
  }
}
