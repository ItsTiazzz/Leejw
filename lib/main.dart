import 'package:flutter/material.dart';
import 'package:leejw/dashboard.dart';
import 'package:leejw/flash_system.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/settings.dart';
import 'package:leejw/voced/voced.dart';
import 'package:provider/provider.dart';

void main() {
  initVocEd();
  runApp(const LeejwApp());
}

class LeejwApp extends StatelessWidget {
  const LeejwApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GlobalState>(
      create: (context) => GlobalState(),
      builder: (context, child) {
        var gState = context.watch<GlobalState>();

        return MaterialApp(
          title: 'Leejw',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: gState.appThemeData,
          home: HomePage(),
        );
      },
    );
  }
}

class GlobalState extends ChangeNotifier {
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

  bool isDarkMode() {
    return _darkMode;
  }

  void _updateTheme() {
    appThemeData = _darkMode ? _dark : _light;

    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var hoveringForExtension = false;
  var extensionOverride = false;

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();
    var selectedIndex = gState.selectedIndex;
    var l10n = AppLocalizations.of(context)!;

    Widget page = switch (selectedIndex) {
      0 => Dashboard(),
      1 => FlashPage(),
      2 => SettingsPage(),
      3 => VocEditorPage(),
      _ => throw UnimplementedError('No "page" widget for requested index: $selectedIndex')
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: MouseRegion(
                  onEnter: (event) => setState(() => hoveringForExtension = true),
                  onExit: (event) => setState(() => hoveringForExtension = false),
                  child: NavigationRail(
                    extended: extensionOverride ? true : hoveringForExtension,
                    minExtendedWidth: 180,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard_outlined),
                        label: Text(l10n.dashboard_title),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.flash_on_outlined),
                        label: Text(l10n.flashcards_title),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_suggest_outlined),
                        label: Text(l10n.settings_title)
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.collections_bookmark_outlined), 
                        label: Text(l10n.voced_title)
                      )
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        gState.setSelectedIndex(value);
                      });
                    },
                  ),
                ),
                // child: NavigationBar(
                //   onDestinationSelected: (value) {
                //     setState(() => gState.setSelectedIndex(value));
                //   },
                //   selectedIndex: selectedIndex,
                //   destinations: [
                //     NavigationDestination(
                //       icon: Icon(Icons.dashboard_outlined),
                //       label: l10n.dashboard_title,
                //     ),
                //     NavigationDestination(
                //       icon: Icon(Icons.flash_on_outlined),
                //       label: l10n.flashcards_title,
                //     ),
                //     NavigationDestination(
                //       icon: Icon(Icons.settings_suggest_outlined),
                //       label: l10n.settings_title,
                //     ),
                //     NavigationDestination(
                //       icon: Icon(Icons.collections_bookmark_outlined), 
                //       label: l10n.voced_title,
                //     )
                //   ]
                // ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
          floatingActionButton: MouseRegion(
            onEnter: (event) => setState(() => hoveringForExtension = true),
            onExit: (event) => setState(() => hoveringForExtension = false),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => gState.nextMode(),
                  icon: Icon(gState.isDarkMode() ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                ),
                IconButton(
                  onPressed: () => setState(() => extensionOverride = !extensionOverride),
                  icon: Icon(extensionOverride ? Icons.push_pin : Icons.push_pin_outlined,),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        );
      }
    );
  }
}