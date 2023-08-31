import 'package:flutter/material.dart';
import 'package:indices_bidirectional/app_constants.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // APPLICATION ROOT
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Bidirectional Indices',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColorDark: Colors.black,
          primaryColorLight: Colors.blueGrey
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final keyController = TextEditingController();
  final valController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    var value = await context.read<AppState>().readCounter();
    setState(() {
      _counter = value;
    });
    context.read<AppState>().initialize();
    _incrementCounter();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    context.read<AppState>().writeCounter(_counter);
  }

  @override
  void dispose() {
    keyController.dispose();
    valController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: keyController,
            ),
            TextField(
              controller: valController,
            ),
            ElevatedButton(
              onPressed: () {
                //addToIndex(appState, "", "");
                setState(() {
                  appState.addToIndex(keyController.text, valController.text);
                });
              },
              child: const Text("Add to Index"),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 400,
              child:
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('You have '
                        '${appState.index.length} entries in your index:'),
                  ),
                  for (var entry in appState.index.entries)
                    ListTile(
                      leading: const Icon(Icons.arrow_right),
                      title: Text(AppConstants.entryText(entry)),
                    ),
                ],
              ),
            ),
            const Text(
              'Persistence verifier -- You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // bool addToIndex(AppState state, String key, String val) {
  //   return state.addToIndex(key, val);
  // }
}
