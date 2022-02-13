import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graph_bloc/graph_bloc.dart';

abstract class ExampleEvent extends Equatable {
  const ExampleEvent();

  @override
  List<Object?> get props => [];
}

class ExampleEventLoad extends ExampleEvent {
  const ExampleEventLoad();
}

class ExampleEventIncrement extends ExampleEvent {
  const ExampleEventIncrement();
}

class ExampleEventDecrement extends ExampleEvent {
  const ExampleEventDecrement();
}

class ExampleEventReset extends ExampleEvent {
  const ExampleEventReset();
}

class ExampleEventError extends ExampleEvent {
  const ExampleEventError({this.error});

  final Object? error;

  @override
  List<Object?> get props => [error];
}

abstract class ExampleState extends Equatable {
  const ExampleState();

  @override
  List<Object?> get props => [];
}

class ExampleStateLoading extends ExampleState {
  const ExampleStateLoading();
}

class ExampleStateLoaded extends ExampleState {
  const ExampleStateLoaded([this.counter = 0]);

  final int counter;

  @override
  List<Object?> get props => [counter];
}

class ExampleStateError extends ExampleState {
  const ExampleStateError([this.error]);

  final Object? error;

  @override
  List<Object?> get props => [error];
}

// Our bloc that implements our graph.
class ExampleGraphBloc extends GraphBloc<ExampleEvent, ExampleState> {
  ExampleGraphBloc({
    required ExampleState initialState,
  }) : super(initialState: initialState);

  @override
  BlocStateGraph<ExampleEvent, ExampleState> get graph => BlocStateGraph(
        graph: {
          ExampleStateLoading: {
            ExampleEventLoad:
                transition((ExampleEventLoad event, ExampleStateLoading state) {
              return const ExampleStateLoaded(0);
            }),
          },
          ExampleStateLoaded: {
            ExampleEventIncrement: transition(
                (ExampleEventIncrement event, ExampleStateLoaded state) {
              return ExampleStateLoaded(state.counter + 1);
            }),
            ExampleEventDecrement: transition(
                (ExampleEventDecrement event, ExampleStateLoaded state) {
              return ExampleStateLoaded(state.counter - 1);
            }),
          },
        },
        unrestrictedGraph: {
          ExampleEventError: transition((event, state) {
            return const ExampleStateError('Failed loading');
          }),
          ExampleEventReset:
              transition(((event, state) => const ExampleStateLoaded(0))),
        },
      );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  ExampleGraphBloc bloc =
      ExampleGraphBloc(initialState: const ExampleStateLoaded());

  void _incrementCounter() {
    bloc.add(const ExampleEventIncrement());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<ExampleState>(
              stream: bloc.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data is ExampleStateLoaded) {
                  return Text(
                    '${(snapshot.data as ExampleStateLoaded).counter}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                }

                return const SizedBox.shrink();
              },
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
}
