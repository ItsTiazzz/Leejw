import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
  final _light3 = ThemeData.light(useMaterial3: true);
  final _dark3 = ThemeData.dark(useMaterial3: true);
  final _light = ThemeData.light(useMaterial3: false);
  final _dark = ThemeData.dark(useMaterial3: false);
  var _darkMode = true;
  var _useMaterial3 = true;

  void nextMode() {
    _darkMode = !_darkMode;

    _updateTheme();
  }

  bool isDarkMode() {
    return _darkMode;
  }

  void nextMaterial() {
    _useMaterial3 = !_useMaterial3;

    _updateTheme();
  }

  bool isMaterialThree() {
    return _useMaterial3;
  }

  void _updateTheme() {
    appThemeData = _darkMode ? _useMaterial3 ? _dark3 : _dark : _useMaterial3 ? _light3 : _light;

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

    Widget page;
    switch (selectedIndex) {
      case 0: page = Dashboard();
      case 1: page = FlashPage();
      case 2: page = SettingsPage();
      default: throw UnimplementedError('No "page" widget for requested index: $selectedIndex');
    }

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
                        label: Text('Dashboard'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.flash_on_outlined),
                        label: Text('Flashcards'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_suggest_outlined),
                        label: Text("Settings")
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

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardEntry(text: "Your progress:", icon: Icon(Icons.flash_on_outlined), onPressed: (gState) => gState.setSelectedIndex(1),),
              DashboardEntry(text: "Settings:", icon: Icon(Icons.settings_suggest_outlined), onPressed: (gState) => gState.setSelectedIndex(2),),
            ],
          )
        ],
      ),
    );
  }
}

class DashboardEntry extends StatelessWidget {
  const DashboardEntry({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final Icon icon;
  final Function(GlobalState gState) onPressed;

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();
    var theme = Theme.of(context);

    return Card(
      elevation: 8,
      child: Padding(
      padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: theme.textTheme.displaySmall,
            ),
            SizedBox(height: 10,),
            IconButton(
              onPressed: () => onPressed(gState),
              icon: icon,
            ),
          ],
        ),
      ),
    );
  }
}

class FlashPage extends StatelessWidget {
  const FlashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Placeholder()
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SettingTitleCard(title: "Theme"),
        SettingCard(
          message: (gState) => "Change to ${gState.isDarkMode() ? "light" : "dark"} mode.",
          icon: (gState) => Icon(gState.isDarkMode() ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onTap: (gState) => gState.nextMode(),
        ),
        SettingCard(
          message: (gState) => "Use material3.",
          icon: (gState) => Icon(gState.isMaterialThree() ? Icons.check_circle_outline : Icons.circle_outlined),
          onTap: (gState) => gState.nextMaterial(),
        ),
      ],
    );
  }
}

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.message,
    required this.onTap,
    required this.icon,
  });

  final String Function(GlobalState gState) message;
  final Function(GlobalState gState) onTap;
  final Icon Function(GlobalState gState)? icon;

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        leading: icon!(gState),
        title: Text(message(gState)),
        onTap: () => onTap(gState),
      ),
    );
  }
}

class SettingTitleCard extends StatelessWidget {
  const SettingTitleCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(20, 30))),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        leading: Icon(Icons.format_paint_outlined),
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium,),
      ),
    );
  }
}