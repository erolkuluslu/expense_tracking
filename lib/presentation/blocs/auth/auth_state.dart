part of 'auth_bloc.dart';

/// Base class for all authentication states
/// Uses [Equatable] for value comparison
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// Initial authentication state when the app starts
final class AuthInitial extends AuthState {}

/// State indicating authentication is in progress
final class AuthLoading extends AuthState {}

/// State representing successful authentication
/// Contains the authenticated user's email and password
final class AuthSuccess extends AuthState {
  final String email;
  final String password;
  const AuthSuccess({required this.email, required this.password});
}

/// State representing failed authentication
/// Contains an error message describing the failure reason
final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
