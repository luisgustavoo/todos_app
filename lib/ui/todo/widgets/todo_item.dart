import 'package:flutter/material.dart';
import 'package:todos_app/domain/models/todo.dart';
import 'package:todos_app/ui/core/themes/colors.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    required this.todo,
    this.onChange,
    super.key,
  });

  final Todo todo;
  final void Function(Todo todo)? onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        value: todo.isDone,
        onChanged: (value) {
          onChange?.call(
            todo.copyWith(isDone: value!),
          );
        },
      ),
    );
  }
}
