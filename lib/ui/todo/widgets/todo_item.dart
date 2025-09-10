import 'package:flutter/material.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/core/themes/colors.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.todo,
    required this.animation,
    this.onChange,
    this.onRemove,
    this.isLast = false,
    super.key,
  });

  final Todo todo;
  final void Function(Todo todo)? onChange;
  final void Function(Todo todo)? onRemove;
  final Animation<double> animation;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Column(
        children: [
          ListTile(
            title: Text(
              todo.description,
              style: todo.isDone
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2,
                      decorationColor: AppColors.grey3,
                      color: AppColors.grey3,
                    )
                  : null,
            ),
            leading: Checkbox(
              key: Key('checkbox-${todo.id}'),
              value: todo.isDone,
              onChanged: (value) {
                onChange?.call(
                  todo.copyWith(isDone: value!),
                );
              },
            ),
            trailing: IconButton(
              onPressed: () {
                onRemove?.call(todo);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ),
          if (!isLast)
            const Divider(
              indent: 75,
            ),
        ],
      ),
    );
  }
}
