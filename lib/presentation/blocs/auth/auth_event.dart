part of 'auth_bloc.dart';

/// Base class for all authentication events
/// Uses [Equatable] for value comparison
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when a user requests to log in
/// Contains the user's email and password credentials
final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});
  final String email;
  final String password;
}
