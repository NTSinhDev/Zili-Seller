part of 'collaborator_cubit.dart';

abstract class CollaboratorState extends Equatable {
  const CollaboratorState({this.event = ''});
  final String event;

  @override
  List<Object> get props => [event];
}

class CollaboratorInitial extends CollaboratorState {}

class CollaboratorLoadingState extends CollaboratorState {
  const CollaboratorLoadingState({super.event = ''});
}

class CollaboratorLoadedState extends CollaboratorState {
  final List<Collaborator> collaborators;
  const CollaboratorLoadedState(this.collaborators);

  @override
  List<Object> get props => [collaborators];
}

class CollaboratorErrorState extends CollaboratorState {
  final dynamic error;
  const CollaboratorErrorState({this.error});
}

