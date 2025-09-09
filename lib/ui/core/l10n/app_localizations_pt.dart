// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get todoList => 'Lista de Tarefas';

  @override
  String get all => 'Todos';

  @override
  String get pending => 'Pendentes';

  @override
  String get done => 'Concluídas';

  @override
  String get save => 'Salvar';

  @override
  String get enterTheTask => 'Digite a tarefa...';

  @override
  String get errorSavingTask => 'Erro ao salvar tarefa.';

  @override
  String get errorUpdatingTask => 'Erro ao atualizar tarefa.';

  @override
  String get errorDeletingTask => 'Erro ao deletar tarefa.';

  @override
  String get noPendingTasks => 'Nenhuma tarefa pendente.';

  @override
  String get noTasksCompleted => 'Nenhuma tarefa concluída.';

  @override
  String get noTasksRegistered => 'Nenhuma tarefa cadastrada.';
}
