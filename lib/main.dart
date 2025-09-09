import 'package:flutter/material.dart';
import 'package:todos_app/config/dependencies.dart';
import 'package:todos_app/routing/router.dart';
import 'package:todos_app/ui/core/l10n/app_localizations.dart';
import 'package:todos_app/ui/core/themes/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'To do list',
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
    );
  }
}
