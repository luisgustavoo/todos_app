import 'package:flutter/material.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/core/l10n/l10n.dart';
import 'package:todos_app/ui/core/themes/dimens.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/ui/todo/widgets/todo_add.dart';
import 'package:todos_app/ui/todo/widgets/todo_item.dart';

const String addTodoButtonKey = 'add-todo-button';
const String todoDoneButtonKey = 'todo-done-button';
const String filterSegmentedKey = 'filter-segmented-button';

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
  late final TodoViewModel _viewModel;
  late GlobalKey<AnimatedListState> _listKey;
  AnimatedListState? get _animatedList => _listKey.currentState;
  @override
  void initState() {
    super.initState();
    _viewModel = widget.todoViewModel;
    _listKey = GlobalKey<AnimatedListState>();
    _viewModel.saveTodo.addListener(_onSave);
    _viewModel.updateTodo.addListener(_onUpdate);
    _viewModel.deleteTodo.addListener(_onDelete);
    _viewModel.find.addListener(_onFind);
  }

  @override
  void didUpdateWidget(covariant TodoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _viewModel.saveTodo.removeListener(_onSave);
    _viewModel.saveTodo.addListener(_onSave);
    _viewModel.updateTodo.removeListener(_onUpdate);
    _viewModel.updateTodo.addListener(_onUpdate);
    _viewModel.deleteTodo.removeListener(_onDelete);
    _viewModel.deleteTodo.addListener(_onDelete);
    _viewModel.find.removeListener(_onFind);
    _viewModel.find.addListener(_onFind);
  }

  @override
  void dispose() {
    _viewModel.saveTodo.removeListener(_onSave);
    _viewModel.updateTodo.removeListener(_onUpdate);
    _viewModel.deleteTodo.removeListener(_onDelete);
    _viewModel.find.removeListener(_onFind);
    super.dispose();
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
              listenable: _viewModel.toggleStatus,
              builder: (context, child) {
                return SegmentedButton<TodoStatus>(
                  key: const Key('filter-segmented-button'),
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
                        key: const Key('todo-done-button'),
                        context.l10n.done,
                      ),
                    ),
                  ],
                  selected: <TodoStatus>{_viewModel.status},
                  onSelectionChanged: (newSelection) {
                    _listKey = GlobalKey<AnimatedListState>();
                    _viewModel.toggleStatus.execute(newSelection.first);
                  },
                );
              },
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, child) {
                  if (_viewModel.todos.isEmpty) {
                    final text = switch (_viewModel.status) {
                      TodoStatus.pending => context.l10n.noPendingTasks,
                      TodoStatus.done => context.l10n.noTasksCompleted,
                      _ => context.l10n.noTasksRegistered,
                    };
                    return Center(
                      child: Text(text),
                    );
                  }
                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: _viewModel.itemCount,
                    itemBuilder: _buildItem,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key(addTodoButtonKey),
        onPressed: () {
          _openAddTodoSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _removeTodo(Todo todo) {
    _viewModel.deleteTodo.execute((
      todo: todo,
      animatedList: _animatedList,
      removedItemBuilder: (context, animation) {
        return _buildRemovedItem(todo, context, animation);
      },
    ));
  }

  Widget _buildRemovedItem(
    Todo todo,
    BuildContext context,
    Animation<double> animation,
  ) {
    return TodoItem(
      todo: todo,
      animation: animation,
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return TodoItem(
      todo: _viewModel.todos[index],
      isLast: _viewModel.todos[index] == _viewModel.todos.last,
      animation: animation,
      onChange: (todo) async {
        await _viewModel.updateTodo.execute(
          (
            todo: todo,
            animatedList: _animatedList,
            removedItemBuilder: (context, animation) {
              return _buildRemovedItem(todo, context, animation);
            },
          ),
        );
      },
      onRemove: _removeTodo,
    );
  }

  Future<void> _openAddTodoSheet(BuildContext context) async {
    final description = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const TodoAdd(),
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (description != null && description.trim().isNotEmpty) {
      await _viewModel.saveTodo.execute(
        (
          todo: Todo.create(description: description),
          animatedList: _animatedList,
        ),
      );
    }
  }

  void _onFind() {
    if (_viewModel.find.error) {
      _viewModel.find.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.weWereUnableToLoadYourTasks,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSave() {
    if (_viewModel.saveTodo.error) {
      _viewModel.saveTodo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.errorSavingTask,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onUpdate() {
    if (_viewModel.updateTodo.error) {
      _viewModel.updateTodo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.errorUpdatingTask,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onDelete() {
    if (_viewModel.deleteTodo.error) {
      _viewModel.deleteTodo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.errorDeletingTask,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
