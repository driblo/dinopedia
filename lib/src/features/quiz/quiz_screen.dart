import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.quizTitle)),
      body: Center(
        child: FilledButton(
          onPressed: () {},
          child: Text(l10n.quizStart),
        ),
      ),
    );
  }
}
