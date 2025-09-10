import 'package:todos_app/utils/result.dart';

extension ResultCast<T> on Result<T> {
  Ok<T> get asOk => this as Ok<T>;

  Error<T> get asError => this as Error<T>;
}
