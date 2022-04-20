// Type definitions.

/// {@template state_transition_caller}
/// An entry in the [BlocStateGraph] that describes a state [transition]. With an optional [sideEffect]
/// {@endtemplate}
class StateTransitionCaller<Event, State> {
  /// {@macro state_transition_caller}
  const StateTransitionCaller._({this.transition, this.sideEffect});

  const factory StateTransitionCaller.fromTransition(
          {StateTransition<Event, State, State>? transition}) =
      StateTransitionCaller;

  const factory StateTransitionCaller.fromSideEffect(
      {SideEffect<Event, State>? sideEffect}) = StateTransitionCaller;

  const factory StateTransitionCaller({
    StateTransition<Event, State, State>? transition,
    SideEffect<Event, State>? sideEffect,
  }) = StateTransitionCaller._;

  /// The [transition] that is called when the [StateTransitionCaller] is called.
  final StateTransition<Event, State, State>? transition;

  /// The [sideEffect] that is called when the [StateTransitionCaller] is called.
  final SideEffect<Event, State>? sideEffect;
}

// Transition builder function.
typedef StateTransition<Event, In, Out> = Out Function(Event event, In state);

// Side effect function.
typedef SideEffect<Event, State> = void Function(Event event, State state);

// Helper functions.
StateTransitionCaller<Event, State>
    transition<Event, State, REvent extends Event, InState extends State>(
  StateTransition<REvent, InState, State> transition,
) =>
        StateTransitionCaller<Event, State>(
          transition: (event, state) =>
              transition(event as REvent, state as InState),
        );

StateTransitionCaller<Event, State> transitionWithEffect<Event, State,
        REvent extends Event, InState extends State>(
  StateTransition<REvent, InState, State> transition,
  SideEffect<REvent, InState> sideEffect,
) =>
    StateTransitionCaller<Event, State>(
      transition: (event, state) =>
          transition(event as REvent, state as InState),
      sideEffect: (event, state) =>
          sideEffect(event as REvent, state as InState),
    );

StateTransitionCaller<Event, State>
    sideEffect<Event, State, REvent extends Event, InState extends State>(
  SideEffect<REvent, InState> sideEffect,
) =>
        StateTransitionCaller<Event, State>(
          sideEffect: (event, state) =>
              sideEffect(event as REvent, state as InState),
        );
