part of 'app_cubit.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitialState extends AppState {}

class AppReadyState extends AppState {
  final String? message;
  const AppReadyState({this.message});
}

class AppLoginSuccessState extends AppState {}

class AppLogoutSuccessState extends AppState {}

class AppManualLogoutSuccessState extends AppState {}

class AppReadyWithAuthenticationState extends AppState {
  const AppReadyWithAuthenticationState({
    this.user,
    this.hasLoading = false,
  });

  final User? user;
  final bool hasLoading;

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'AppReadyWithAuthenticationState { crUser: $user }';
}

class RefreshAppState extends AppManualLogoutSuccessState {}

class AppUnauthorizedState extends AppState {}