import 'package:flutter_test/flutter_test.dart';
import 'package:todos_app/data/repositories/todo/todo_repository_local.dart';
import 'package:todos_app/data/services/local/local_data_service.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/utils/result.dart';

import '../../../../testing/fakes/services/fake_shared_preferences_service.dart';

void main() {
  final todoRepositoryLocal = TodoRepositoryLocal(
    localDataService: LocalDataService(FakeSharedPreferencesService()),
  );

  final kTodo = Todo.create(description: 'Task');

  group('Todo repository local ...', () {
    test(
      'Deve salvar uma tarefa no SharedPreferences',
      () async {
        final result = await todoRepositoryLocal.saveTodo(kTodo);
        expect(result, isA<Ok<void>>());
        expect(todoRepositoryLocal.todos.length, 1);
        expect(todoRepositoryLocal.todos.first.description, 'Task');
      },
    );
    test(
      'Deve salvar uma busca as tarefas no SharedPreferences',
      () async {
        final result = await todoRepositoryLocal.find(TodoStatus.all);
        expect(result, isA<Ok<void>>());
        expect(todoRepositoryLocal.todos.length, 1);
        expect(todoRepositoryLocal.todos.first.description, 'Task');
      },
    );
    test(
      'Deve deletar uma  tarefas no SharedPreferences',
      () async {
        await todoRepositoryLocal.saveTodo(kTodo);
        final result = await todoRepositoryLocal.delete(kTodo.id);
        expect(result, isA<Ok<void>>());
        expect(todoRepositoryLocal.todos, isEmpty);
      },
    );
  });
}
