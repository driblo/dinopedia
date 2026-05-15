import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.dinoId});

  final String dinoId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(dinoId)),
      body: Center(child: Text(l10n.detailLoadingWiki)),
    );
  }
}
