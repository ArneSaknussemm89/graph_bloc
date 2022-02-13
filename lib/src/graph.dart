import 'package:graph_bloc/graph_bloc.dart';

/// A class representing a declarative graph that defines every possible Event -> State transitions.
///
/// This concept ensures that a bloc behaves like a FSM (Finite State Machine) where incorrect states
/// are impossible as every possible path is predefined.
///
/// @TODO: Add documentation and examples
class BlocStateGraph<Event, State> {
  /// {@macro graph}
  const BlocStateGraph({
    required this.graph,
    this.unrestrictedGraph = const {},
  });

  // Our graph defition.
  final Map<Type, Map<Type, StateTransitionCaller<Event, State>>> graph;

  // An unrestricted graph of events that do not need to match state prior to being called.
  final Map<Type, StateTransitionCaller<Event, State>> unrestrictedGraph;

  /// Makes a transition from [state] to [nextState] using [event] based on [graph].
  State call(Event event, State state) {
    final transition = getTransitionFor(event, state);
    // An incorrect transition is simply ignored.
    if (transition == null) return state;
    return transition.transition?.call(event, state) ?? state;
  }

  void callSideEffect(Event event, State state) {
    final transition = getTransitionFor(event, state);
    transition?.sideEffect?.call(event, state);
  }

  StateTransitionCaller<Event, State>? getTransitionFor(
      Event event, State state) {
    final stateEntry = graph[state.runtimeType];
    if (stateEntry != null) {
      final transition = stateEntry[event.runtimeType];
      if (transition != null) return transition;
    }

    final unrestrictedEntry = unrestrictedGraph[event.runtimeType];
    if (unrestrictedEntry != null) return unrestrictedEntry;

    // Nothing found so nothing returned.
    return null;
  }
}
