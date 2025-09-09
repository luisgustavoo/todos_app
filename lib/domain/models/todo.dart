import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

const _uuid = Uuid();

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String description,
    @Default(false) bool isDone,
  }) = _Todo;

  factory Todo.create({required String description}) {
    return Todo(
      id: _uuid.v7(),
      description: description,
    );
  }

  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
}
