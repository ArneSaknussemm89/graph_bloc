import 'package:flutter_test/flutter_test.dart';

import 'data/data.dart';

void main() {
  Future<void> delay() => Future.delayed(const Duration(milliseconds: 300));

  test('test the graph flows', () async {
    final bloc = ExampleGraphBloc(initialState: const ExampleStateLoading());
    bloc.add(const ExampleEventLoad());
    // Wait for streams to populate.
    await delay();

    expect(bloc.state, const ExampleStateLoaded(0));

    // Increment bloc.
    bloc.add(const ExampleEventIncrement());

    await delay();

    // Ensure the bloc incremented the state.
    expect(bloc.state, const ExampleStateLoaded(1));

    // Now test making sure that this event is ignored since it does not
    // follow the graph.
    bloc.add(const ExampleEventLoad());

    await delay();

    expect(bloc.state, const ExampleStateLoaded(1));

    // Now test the global reset event.
    bloc.add(const ExampleEventReset());

    await delay();

    expect(bloc.state, const ExampleStateLoaded(0));
  });
}
