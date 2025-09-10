import 'package:todos_app/data/services/shared_preferences_service.dart';
import 'package:todos_app/utils/result.dart';

class FakeSharedPreferencesService implements SharedPreferencesService {
  String value = '';

  @override
  Future<Result<String?>> getTodos() {
    return Future.value(Result.ok(value));
  }

  @override
  Future<Result<void>> setTodos(String value) {
    this.value = value;
    return Future.value(const Result.ok(null));
  }
}
