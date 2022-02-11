import 'package:bloc/bloc.dart';
import 'package:graph_bloc/graph_bloc.dart';

mixin BlocStateGraphMixin<Event, State> {
  BlocStateGraph<Event, State> get graph;
}

/// The basic class for a GraphBloc.
abstract class GraphBloc<Event, State> extends Bloc<Event, State> with BlocStateGraphMixin<Event, State> {
  GraphBloc({required State initialState}) : super(initialState) {
    // configure a single on<Event> handler that passes the event to the _handleGraphEvent function
    // that's in charge of using [graph] to determine the next state.
    on<Event>((event, emit) => _handleGraphEvent(event, emit));
    _graph = graph;
  }

  late final BlocStateGraph<Event, State> _graph;

  // Check if the event is handled by the graph.
  void _handleGraphEvent(Event event, Emitter emit) {
    final transition = _graph.getTransitionFor(event, state);
    if (transition == null) {
      return;
    }

    // Get the new state based on the transition and then emit.
    final newState = transition.transition?.call(event, state) ?? state;
    emit(newState);

    // Now that the new state has been emitted, let's call sideEffect.
    transition.sideEffect?.call(event, state);
  }
}
