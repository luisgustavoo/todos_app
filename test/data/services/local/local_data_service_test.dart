import 'package:flutter_test/flutter_test.dart';
import 'package:todos_app/data/services/local/local_data_service.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/utils/result.dart';

import '../../../../testing/fakes/services/fake_shared_preferences_service.dart';
import '../../../../testing/utils/result.dart';

void main() {
  late LocalDataService localDataService;
  final kTodo = Todo.create(description: 'Task');
  final fakeSharedPreferencesService = FakeSharedPreferencesService();
  setUp(() {
    localDataService = LocalDataService(fakeSharedPreferencesService);
  });

  group('LocalDataService SharedPreferences operations', () {
    test(
      'should persist new task in SharedPreferences',
      () async {
        final result = await localDataService.saveTodo(kTodo);
        expect(result, isA<Ok<void>>());
      },
    );
    test(
      'should look for tasks in SharedPreferences',
      () async {
        final result = await localDataService.find(TodoStatus.all);
        expect(result, isA<Ok<void>>());
        expect(
          result.asOk.value.first.id,
          kTodo.id,
        );
      },
    );
    test(
      'should delete a task from SharedPreferences',
      () async {
        final result = await localDataService.deleteTodo(kTodo.id);
        expect(result, isA<Ok<void>>());
      },
    );
  });
}
