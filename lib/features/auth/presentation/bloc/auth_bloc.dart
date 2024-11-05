import 'package:flutter_auth_template/core/usecase/usecase.dart';
import 'package:flutter_auth_template/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_auth_template/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final CurrentUser _currentUser;

  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required CurrentUser currentUser,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignOut>(_onAuthSignOut);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }

  void _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) {
    _signOut(NoParams());
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }

  void _onAuthSignIn(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }
}
