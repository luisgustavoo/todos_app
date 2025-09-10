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
    updateTodo = Command1(_updateTodo);
    deleteTodo = Command1(_deleteTodo);
    toggleStatus = Command1(_toggleStatus);
  }

  late final Command0<void> find;
  late final Command1<void, ({Todo todo, AnimatedListState? animatedList})>
  saveTodo;
  late final Command1<
    void,
    ({
      Todo todo,
      AnimatedListState? animatedList,
      Widget Function(BuildContext context, Animation<double> animation)
      removedItemBuilder,
    })
  >
  updateTodo;
  late final Command1<
    void,
    ({
      Todo todo,
      AnimatedListState? animatedList,
      Widget Function(BuildContext context, Animation<double> animation)
      removedItemBuilder,
    })
  >
  deleteTodo;
  late final Command1<void, TodoStatus> toggleStatus;
  final TodoRepository _todoRepository;
  final _log = Logger('TodoViewModel');
  List<Todo> get todos => _todoRepository.todos;
  int get itemCount => _todoRepository.todos.length;
  TodoStatus status = TodoStatus.all;

  Future<Result<void>> _find() async {
    final result = await _todoRepository.find(status);
    switch (result) {
      case Ok():
        notifyListeners();
        return const Result.ok(null);
      case Error():
        _log.warning('Erro ao listar as tarefas error: ${result.error}');
        notifyListeners();
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _saveTodo(
    ({Todo todo, AnimatedListState? animatedList}) saveData,
  ) async {
    final (
      todo: todo,
      animatedList: animatedList,
    ) = saveData;
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    final result = await _todoRepository.saveTodo(todo);
    switch (result) {
      case Ok():
        if (todoIndex < 0 && status != TodoStatus.done) {
          final index = _lastIndex() - 1;
          animatedList?.insertItem(index);
        }
        await _find();
      case Error():
        _log.warning('Erro ao criar tarefa error: ${result.error}');
        notifyListeners();
        return Result.error(result.error);
    }

    return result;
  }

  Future<Result<void>> _deleteTodo(
    ({
      Todo todo,
      AnimatedListState? animatedList,
      Widget Function(BuildContext context, Animation<double> animation)
      removedItemBuilder,
    })
    deleteData,
  ) async {
    final (
      todo: todo,
      animatedList: animatedList,
      removedItemBuilder: removedItemBuilder,
    ) = deleteData;
    final index = _indexOf(todo);
    final result = await _todoRepository.delete(todo.id);
    switch (result) {
      case Ok():
        animatedList?.removeItem(index, removedItemBuilder);
        notifyListeners();
      case Error():
        _log.warning('Erro ao deletar tarefa error: ${result.error}');
        notifyListeners();
        return Result.error(result.error);
    }

    return result;
  }

  Future<Result<void>> _updateTodo(
    ({
      Todo todo,
      AnimatedListState? animatedList,
      Widget Function(BuildContext context, Animation<double> animation)
      removedItemBuilder,
    })
    updateData,
  ) async {
    final (
      todo: todo,
      animatedList: animatedList,
      removedItemBuilder: removedItemBuilder,
    ) = updateData;
    final result = await _todoRepository.saveTodo(todo);
    switch (result) {
      case Ok():
        if (status == TodoStatus.pending) {
          final index = _indexOf(todo);
          animatedList?.removeItem(index, removedItemBuilder);
        }
        await _find();
      case Error():
        _log.warning('Erro ao atualizar tarefa error: ${result.error}');
        notifyListeners();
        return Result.error(result.error);
    }

    return result;
  }

  Future<Result<void>> _toggleStatus(TodoStatus status) async {
    this.status = status;
    return _find();
  }

  int _lastIndex() {
    if (todos.isEmpty) {
      return 0;
    }
    return todos.length;
  }

  int _indexOf(Todo todo) => todos.indexWhere(
    (t) => t.id == todo.id,
  );
}
