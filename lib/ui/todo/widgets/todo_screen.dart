import 'package:flutter/material.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/core/l10n/l10n.dart';
import 'package:todos_app/ui/core/themes/dimens.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/ui/todo/widgets/todo_add.dart';
import 'package:todos_app/ui/todo/widgets/todo_item.dart';

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
  late final GlobalKey<AnimatedListState> _listKey;
  AnimatedListState? get _animatedList => _listKey.currentState;
  int initialItemCount = 0;
  @override
  void initState() {
    super.initState();
    viewModel = widget.todoViewModel;
    _listKey = GlobalKey<AnimatedListState>();
    viewModel.saveTodo.addListener(_onSave);
    initialItemCount = viewModel.todos.length;
  }

  @override
  void didUpdateWidget(covariant TodoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.todoViewModel.saveTodo.removeListener(_onSave);
    widget.todoViewModel.saveTodo.addListener(_onSave);
  }

  @override
  void dispose() {
    viewModel.saveTodo.removeListener(_onSave);
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
                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: viewModel.todos.length,
                    itemBuilder: _buildItem,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _saveTodo() {
    _openAddTodoSheet(context);
  }

  void _removeTodo(Todo todo) {
    viewModel.deleteTodo.execute((
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
      todo: viewModel.todos[index],
      animation: animation,
      onChange: (todo) async {
        await viewModel.saveTodo.execute(
          (
            todo: todo,
            animatedList: _animatedList,
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
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (description != null && description.trim().isNotEmpty) {
      await viewModel.saveTodo.execute(
        (
          todo: Todo.create(description: description),
          animatedList: _animatedList,
        ),
      );
    }
  }

  void _onSave() {
    // if (viewModel.saveTodo.completed) {
    //   _animatedList?.insertItem(0);
    // }

    // if (viewModel.saveTodo.error) {
    //   viewModel.saveTodo.clearResult();
    //   _animatedList?.removeItem(0, (context, animation) {
    //     return _buildItem(context, index, animation)
    //   },);
    // }
  }
}

// typedef _RemovedItemBuilder<T> =
//     Widget Function(T item, BuildContext context, Animation<double> animation);

// class _ListModel<E> {
//   _ListModel({
//     required this.listKey,
//     required this.removedItemBuilder,
//     Iterable<E>? initialItems,
//   }) : _items = List<E>.from(initialItems ?? <E>[]);

//   final GlobalKey<AnimatedListState> listKey;
//   final _RemovedItemBuilder<E> removedItemBuilder;
//   final List<E> _items;

//   AnimatedListState? get _animatedList => listKey.currentState;

//   void insert(int index, E item) {
//     _items.insert(index, item);
//     _animatedList!.insertItem(index);
//   }

//   E removeAt(int index) {
//     final removedItem = _items.removeAt(index);
//     if (removedItem != null) {
//       _animatedList!.removeItem(index, (
//         context,
//         animation,
//       ) {
//         return removedItemBuilder(removedItem, context, animation);
//       });
//     }
//     return removedItem;
//   }

//   int get length => _items.length;

//   E operator [](int index) => _items[index];

//   int indexOf(E item) => _items.indexOf(item);
// }
