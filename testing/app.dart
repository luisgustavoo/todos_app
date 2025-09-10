import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:todos_app/ui/core/l10n/app_localizations.dart';
import 'package:todos_app/ui/core/themes/theme.dart';

import 'mocks.dart';

Future<void> testApp(
  WidgetTester tester,
  Widget body, {
  GoRouter? goRouter,
}) async {
  // tester.view.devicePixelRatio = 1.0;
  // await tester.binding.setSurfaceSize(const Size(1200, 800));

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: InheritedGoRouter(
        goRouter: goRouter ?? MockGoRouter(),
        child: Scaffold(body: body),
      ),
    ),
  );
}
