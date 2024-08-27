import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    void onChange(Change<AuthState> change) {
      super.onChange(change);
      print('AuthBloc- Change: $change');
    }

    void onTransition(Transition<AuthEvent, AuthState> transition) {
      super.onTransition(transition);
      print('AuthBloc - Transition: $transition');
    }

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading()); // The authentication is in progress.

      try {
        final email = event.email;
        final password = event.password;

        final emailRegex =
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

        if (!emailRegex.hasMatch(email)) {
          // the email format is invalid.
          return emit(const AuthFailure("Invalid email format"));
        } else if (password.length < 6) {
          return emit(
              const AuthFailure("Password must be at least 6 characters long"));
        } else {
          await Future.delayed(const Duration(milliseconds: 300));

          return emit(AuthSuccess(email: email, password: password));
        }
      } catch (e) {
        return emit(AuthFailure(e.toString()));
      }
    });
  }
}
