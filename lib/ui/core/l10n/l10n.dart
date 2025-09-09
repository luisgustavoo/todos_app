import 'package:flutter/material.dart';
import 'package:todos_app/ui/core/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
