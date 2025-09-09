import 'package:go_router/go_router.dart';
import 'package:todos_app/config/dependencies.dart';
import 'package:todos_app/routing/routes.dart';
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart';
import 'package:todos_app/ui/todo/widgets/todo_screen.dart';

GoRouter get router => GoRouter(
  initialLocation: Routes.todo,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: Routes.todo,
      builder: (context, state) {
        return TodoScreen(
          todoViewModel: getIt<TodoViewModel>(),
        );
      },
    ),
  ],
);
