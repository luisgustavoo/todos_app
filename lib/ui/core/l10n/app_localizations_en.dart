// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get todoList => 'To do List';

  @override
  String get all => 'All';

  @override
  String get pending => 'pending';

  @override
  String get done => 'done';

  @override
  String get save => 'Save';

  @override
  String get enterTheTask => 'Enter the task...';

  @override
  String get errorSavingTask => 'Error saving task.';

  @override
  String get errorUpdatingTask => 'Error updating task.';

  @override
  String get errorDeletingTask => 'Error deleting task.';

  @override
  String get noPendingTasks => 'No pending tasks.';

  @override
  String get noTasksCompleted => 'No tasks completed.';

  @override
  String get noTasksRegistered => 'No tasks registered.';

  @override
  String get weWereUnableToLoadYourTasks =>
      'We were unable to load your tasks.';
}
