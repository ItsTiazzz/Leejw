import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leejw/dashboard.dart';
import 'package:leejw/flashing/flash_system.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/settings/json/settings.dart';
import 'package:leejw/settings/settings.dart';
import 'package:leejw/voced/lesson_page.dart';
import 'package:leejw/voced/voced.dart';
import 'package:leejw/voced/voced_page.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    printEmojis: false,
    noBoxingByDefault: true,
    excludeBox: {Level.warning: false, Level.error: false, Level.fatal: false},
  ),
);

void main() {
  runApp(const LeejwApp());
  logger.t(
    'Started LeejwApp. Thanks for using Leejw! Learn like a lion hunts.',
  );
}

class LeejwApp extends StatelessWidget {
  const LeejwApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalState>(create: (context) => GlobalState()),
        ChangeNotifierProvider<VocEdState>(create: (context) => VocEdState()),
        ChangeNotifierProvider<FlashState>(create: (context) => FlashState()),
      ],
      builder: (context, child) {
        var gState = Provider.of<GlobalState>(context);

        return MaterialApp(
          title: 'Leejw',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: gState.appThemeData,
          home: HomePage(),
        );
      },
    );
  }
}

class GlobalState with ChangeNotifier {
  var selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  ThemeData appThemeData = ThemeData.dark(useMaterial3: true);
  final _light = ThemeData.light(useMaterial3: true);
  final _dark = ThemeData.dark(useMaterial3: true);
  var _darkMode = true;

  void nextMode() {
    _darkMode = !_darkMode;

    _updateTheme();
  }

  bool isDarkMode() => _darkMode;

  void _updateTheme() {
    appThemeData = _darkMode ? _dark : _light;

    notifyListeners();
  }
  // ThemeData get _light => ThemeData.light(useMaterial3: true);
  // ThemeData get _dark => ThemeData.dark(useMaterial3: true);
  // Settings get settings => Settings("dark");
  // set settings(Settings s) => settings.theme = s.theme;
  // ThemeData get appThemeData {
  //   loadData();
  //   return settings.theme == "light" ? _light : _dark;
  // }
  //
  // void nextMode() {
  //   settings.theme = settings.theme == "light" ? "dark" : "light";
  //   saveData();
  //   loadData();
  // }
  //
  // bool isDarkMode() => settings.theme == "dark";
  //
  // void saveData() async {
  //   try {
  //     var dir = await getApplicationSupportDirectory();
  //     var file = File('${dir.path}/settings.json');
  //     var content = jsonEncode(settings.toJson());
  //     await file.writeAsString(content);
  //   } catch (e) {
  //     logger.e('Failed to save settings: $e');
  //   }
  //   notifyListeners();
  // }
  //
  //  Future<Settings> loadData() async {
  //   try {
  //     var dir = await getApplicationSupportDirectory();
  //     var file = File('${dir.path}/settings.json');
  //     if (await file.exists()) {
  //       var content = await file.readAsString();
  //       var jsonData = jsonDecode(content);
  //       settings = Settings.fromJson(jsonData);
  //     }
  //   } catch (e) {
  //     logger.e('Failed to load settings: $e');
  //   }
  //   notifyListeners();
  //   return settings;
  // }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var extensionOverride = false;

  @override
  Widget build(BuildContext context) {
    var gState = Provider.of<GlobalState>(context);
    var selectedIndex = gState.selectedIndex;
    var l10n = AppLocalizations.of(context)!;

    Widget page = switch (selectedIndex) {
      0 => Dashboard(),
      1 => LessonPage(),
      2 => SettingsPage(),
      3 => VocEditorPage(),
      _ => throw UnimplementedError(
        'No "page" widget for requested index: $selectedIndex',
      ),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: TapRegion(
              onTapInside: (event) {
                gState.setSelectedIndex(0);
                Feedback.forTap(context);
              },
              child: Row(
                children: [
                  Icon(Icons.category_outlined),
                  SizedBox(width: 5),
                  Text('Leejw'),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
              SafeArea(
                child: NavigationBar(
                  onDestinationSelected: (value) =>
                      setState(() => gState.setSelectedIndex(value)),
                  selectedIndex: selectedIndex,
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      label: l10n.dashboard_title,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.collections_bookmark_outlined),
                      label: l10n.lessons_title,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings_suggest_outlined),
                      label: l10n.settings_title,
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.abc_outlined),
                      label: l10n.voced_title,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
