import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/startup_flow.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const IGasUApp());
}

class IGasUApp extends StatelessWidget {
  const IGasUApp({this.showStartupFlow = true, super.key});

  final bool showStartupFlow;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iGasU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: showStartupFlow ? const StartupFlow() : const MainScreen(),
    );
  }
}
