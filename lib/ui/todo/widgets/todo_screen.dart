import 'package:flutter/material.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/core/l10n/l10n.dart';
import 'package:todos_app/ui/core/themes/dimens.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/ui/todo/widgets/todo_item.dart';
import 'package:uuid/uuid.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    required this.todoViewModel,
    super.key,
  });

  final TodoViewModel todoViewModel;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final TodoViewModel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = widget.todoViewModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.todoList),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimens.paddingScreenHorizontal,
          vertical: context.dimens.paddingScreenVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListenableBuilder(
              listenable: viewModel.toggleStatus,
              builder: (context, child) {
                return SegmentedButton<TodoStatus>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: TodoStatus.all,
                      label: Text(
                        context.l10n.all,
                      ),
                    ),
                    ButtonSegment(
                      value: TodoStatus.pending,
                      label: Text(
                        context.l10n.pending,
                      ),
                    ),
                    ButtonSegment(
                      value: TodoStatus.done,
                      label: Text(
                        context.l10n.done,
                      ),
                    ),
                  ],
                  selected: <TodoStatus>{viewModel.status},
                  onSelectionChanged: (newSelection) {
                    viewModel.toggleStatus.execute(newSelection.first);
                  },
                );
              },
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final todo = viewModel.todos[index];

                      return TodoItem(
                        todo: todo,
                        onChange: (todo) {
                          viewModel.saveTodo.execute(todo);
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        indent: 75,
                        thickness: 0.3,
                      );
                    },
                    itemCount: viewModel.todos.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.saveTodo.execute(
            Todo(
              id: const Uuid().v7(),
              description: 'Teste 3',
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
