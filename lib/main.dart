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
          title: 'Namer App',
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

  ThemeData appThemeData = ThemeData.dark(useMaterial3: false);

  ThemeData setAppThemeData(int index) {
    switch(index) {
      case 0: appThemeData = ThemeData.dark(useMaterial3: false);
      case 1: appThemeData = ThemeData.light(useMaterial3: false);
      default: throw UnimplementedError('No app theme for requested index: $index');
    }

    return appThemeData;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();
    var selectedIndex = gState.selectedIndex;

    Widget page;
    switch (selectedIndex) {
      case 0: page = Dashboard();
      case 1: page = FlashPage();
      default: throw UnimplementedError('No "page" widget for requested index: $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 700,
                  minExtendedWidth: 180,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.flash_on),
                      label: Text('Flashcards'),
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
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Text("Go to Flashcards:")
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      gState.setSelectedIndex(1);
                    },
                    label: Icon(Icons.flash_on_outlined),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          TextCard(content: "Test :D")
        ],
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  const TextCard({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onSurface,
    );

    return Card(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Text(
          content,
          style: style
        ),
      ),
    );
  }
}