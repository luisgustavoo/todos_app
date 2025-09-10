import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_app/data/repositories/todo/todo_repository_local.dart';
import 'package:todos_app/data/services/local/local_data_service.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/ui/todo/widgets/todo_screen.dart';

import '../../../../testing/app.dart';
import '../../../../testing/fakes/services/fake_shared_preferences_service.dart';
import '../../../../testing/mocks.dart';

void main() {
  late MockGoRouter goRouter;
  late TodoViewModel todoViewModel;

  Future<void> addTodo(
    WidgetTester tester, {
    String description = 'Task 1',
  }) async {
    await tester.tap(find.byKey(const ValueKey('add-todo-button')));
    await tester.pumpAndSettle();

    final inputDescription = find.byKey(const ValueKey('input-description'));
    final saveButton = find.byKey(const ValueKey('save-button'));

    await tester.enterText(inputDescription, description);
    await tester.pumpAndSettle();

    await tester.tap(saveButton);
    await tester.pumpAndSettle();
  }

  setUp(
    () {
      goRouter = MockGoRouter();
      todoViewModel = TodoViewModel(
        todoRepository: TodoRepositoryLocal(
          localDataService: LocalDataService(
            FakeSharedPreferencesService(),
          ),
        ),
      );
    },
  );

  Future<void> loadWidget(WidgetTester tester) async {
    await testApp(
      tester,
      TodoScreen(todoViewModel: todoViewModel),
      goRouter: goRouter,
    );
  }

  group('todo screen ...', () {
    testWidgets('Deve mostrar a tela inicial', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();
      expect(find.text('Nenhuma tarefa cadastrada.'), findsOneWidget);
    });
    testWidgets('Deve cadastrar uma tarefa', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();
      await addTodo(tester);
      expect(find.text('Task 1'), findsOneWidget);
    });
    testWidgets('Deve remover uma tarefa', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();
      await addTodo(tester);
      final deleteButton = find.byIcon(Icons.delete_outline);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      expect(find.text('Nenhuma tarefa cadastrada.'), findsOneWidget);
    });

    testWidgets('Deve marcar uma tarefa como concluída', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();
      await addTodo(tester);
      final checkButton = find.byType(Checkbox);
      await tester.tap(checkButton);
      await tester.pumpAndSettle();
    });
    testWidgets('Deve filtrar tarefas concluídas', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();
      await addTodo(tester);
      final checkButton = find.byType(Checkbox);
      await tester.tap(checkButton);
      await tester.pumpAndSettle();
      final doneButton = find.byKey(const Key('todo-done-button'));
      await tester.tap(doneButton);
      await tester.pumpAndSettle();
      expect(find.text('Task 1'), findsOneWidget);
    });

    testWidgets('Deve filtrar tarefas pendentes', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();
      await addTodo(tester);
      await addTodo(tester, description: 'Task 2');
      final checkButton = find.byType(Checkbox);
      await tester.tap(checkButton.at(1));
      await tester.pumpAndSettle();
      final pendingButton = find.byKey(const Key('todo-pending-button'));
      await tester.tap(pendingButton);
      await tester.pumpAndSettle();
      expect(find.text('Task 1'), findsOneWidget);
    });
  });
}
