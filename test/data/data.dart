import 'package:equatable/equatable.dart';
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
