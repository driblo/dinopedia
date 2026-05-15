import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/app_widget.dart';
import 'src/data/hive_boxes.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await HiveBoxes.init();

  FlutterNativeSplash.remove();

  runApp(
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}
