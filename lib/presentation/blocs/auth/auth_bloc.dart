/// Authentication Bloc that handles user authentication state and events
/// This bloc manages the authentication flow including login validation and state management
library;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// [AuthBloc] handles the authentication logic and state management
/// It processes login requests and maintains the current authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    /// Logs state changes for debugging purposes
    void onChange(Change<AuthState> change) {
      super.onChange(change);
      print('AuthBloc- Change: $change');
    }

    /// Logs transitions between states for debugging purposes
    void onTransition(Transition<AuthEvent, AuthState> transition) {
      super.onTransition(transition);
      print('AuthBloc - Transition: $transition');
    }

    /// Handles login request events
    /// Validates email format and password length before authenticating
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading()); // The authentication is in progress.

      try {
        final email = event.email;
        final password = event.password;

        // Regular expression for email validation
        final emailRegex =
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

        // Validate email format
        if (!emailRegex.hasMatch(email)) {
          return emit(const AuthFailure('Invalid email format'));
        }
        // Validate password length
        else if (password.length < 6) {
          return emit(
            const AuthFailure('Password must be at least 6 characters long'),
          );
        }
        // Simulate authentication delay and emit success
        else {
          await Future.delayed(const Duration(milliseconds: 300));
          return emit(AuthSuccess(email: email, password: password));
        }
      } catch (e) {
        return emit(AuthFailure(e.toString()));
      }
    });
  }
}
