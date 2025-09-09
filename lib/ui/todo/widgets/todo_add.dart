import 'package:flutter/material.dart';
import 'package:todos_app/ui/core/l10n/l10n.dart';
import 'package:todos_app/ui/core/themes/dimens.dart';

class TodoAdd extends StatefulWidget {
  const TodoAdd({super.key});

  @override
  State<TodoAdd> createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: dimens.paddingScreenVertical,
          horizontal: dimens.paddingScreenHorizontal,
        ),
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.enterTheTask,
              ),
              onSubmitted: (_) => _save(),
            ),
            ElevatedButton(
              onPressed: _save,
              child: Text(context.l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
