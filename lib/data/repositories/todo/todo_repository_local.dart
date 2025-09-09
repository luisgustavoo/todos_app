import 'package:injectable/injectable.dart';
import 'package:todos_app/data/repositories/todo/todo_repository.dart';
import 'package:todos_app/data/services/local/local_data_service.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/utils/result.dart';

@Singleton(as: TodoRepository)
class TodoRepositoryLocal implements TodoRepository {
  TodoRepositoryLocal({
    required LocalDataService localDataService,
  }) : _localDataService = localDataService {
    find(TodoStatus.all);
  }

  final LocalDataService _localDataService;

  List<Todo> _cache = [];

  @override
  List<Todo> get todos => _cache;

  @override
  Future<Result<void>> saveTodo(Todo todo) {
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      _cache[todoIndex] = todo;
    } else {
      _cache.add(todo);
    }
    return _localDataService.saveTodo(todo);
  }

  @override
  Future<Result<void>> delete(String id) {
    _cache.removeWhere(
      (todo) => todo.id == id,
    );
    return _localDataService.deleteTodo(id);
  }

  @override
  Future<Result<List<Todo>>> find(TodoStatus status) async {
    final result = await _localDataService.find(status);
    switch (result) {
      case Ok<List<Todo>>():
        _cache = [...result.value];
      case Error():
      // Do nothing
    }
    return result;
  }
}
