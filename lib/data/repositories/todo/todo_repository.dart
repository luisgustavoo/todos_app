import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/utils/result.dart';

abstract class TodoRepository {
  List<Todo> get todos;
  Future<Result<void>> saveTodo(Todo todo);
  Future<Result<List<Todo>>> find(TodoStatus status);
  Future<Result<void>> delete(String id);
}
