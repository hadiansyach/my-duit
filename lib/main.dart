import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_duit/core/theme/app_theme.dart';
import 'package:my_duit/core/theme/theme_mode_provider.dart';
import 'package:my_duit/features/main_nav/presentation/pages/main_nav_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);

    return MaterialApp(
      title: 'MyDuit',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const MainNavScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
