import 'package:injectable/injectable.dart';
import 'package:todos_app/data/repositories/todo/todo_repository.dart';
import 'package:todos_app/data/services/local/local_data_service.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/utils/result.dart';

@Injectable(as: TodoRepository)
class TodoRepositoryLocal implements TodoRepository {
  TodoRepositoryLocal({
    required LocalDataService localDataService,
  }) : _localDataService = localDataService;

  final LocalDataService _localDataService;
  @override
  Future<Result<void>> saveTodo(Todo todo) {
    return _localDataService.saveTodo(todo);
  }

  @override
  Future<Result<void>> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Todo>>> find(TodoStatus status) {
    return _localDataService.find(status);
  }
}
