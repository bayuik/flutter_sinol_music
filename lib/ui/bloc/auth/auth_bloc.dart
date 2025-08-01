import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:masterstudy_app/data/repository/auth_repository.dart';

import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(InitialAuthState()) {
    on<RegisterEvent>(
      (event, emit) async {
        emit(LoadingAuthState());
        try {
          await _repository.register(event.login, event.email, event.password);
          emit(SuccessAuthState());
        } catch (error, stacktrace) {
          try {
            var errorData =
                json.decode((error as DioError).response.toString());
            emit(ErrorAuthState(errorData['message']));
          } catch (e) {
            emit(ErrorAuthState("Something went wrong"));
          }
        }
      },
    );
    on<LoginEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        await _repository.authUser(event.login, event.password);
        emit(SuccessAuthState());
      } catch (error, stacktrace) {
        try {
          var errorData = json.decode((error as DioError).response.toString());
          emit(ErrorAuthState(errorData['message']));
        } catch (e) {
          emit(ErrorAuthState("Something went wrong"));
        }
      }
    });
    on<DemoAuthEvent>((event, emit) async {
      emit(LoadingAuthState());
      try {
        await _repository.demoAuth();
        emit(SuccessAuthState());
      } catch (error, stacktrace) {
        try {
          var errorData = json.decode((error as DioError).response.toString());
          emit(ErrorAuthState(errorData['message']));
        } catch (e) {
          emit(ErrorAuthState("Something went wrong"));
        }
      }
    });
    on<CloseDialogEvent>((event, emit) async {
      emit(InitialAuthState());
    });
  }

  // @override
  // Stream<AuthState> mapEventToState(
  //   AuthEvent event,
  // ) async* {
  //   if (event is RegisterEvent) {
  //     yield* _mapRegisterEventToState(event);
  //   }
  //   if (event is LoginEvent) {
  //     yield* _mapSignInEventToState(event);
  //   }
  //   if (event is DemoAuthEvent) {
  //     yield* _mapDemoEventToState(event);
  //   }
  //   if (event is CloseDialogEvent) {
  //     yield InitialAuthState();
  //   }
  // }

  // Stream<AuthState> _errorToState(message) async* {
  //   yield ErrorAuthState(message);
  //   //yield InitialAuthState();
  // }

  // Stream<AuthState> _mapRegisterEventToState(event) async* {
  //   yield LoadingAuthState();
  //   try {
  //     await _repository.register(event.login, event.email, event.password);
  //     yield SuccessAuthState();
  //   } catch (error, stacktrace) {
  //     var errorData = json.decode(error.response.toString());
  //     yield* _errorToState(errorData['message']);
  //   }
  // }

  // Stream<AuthState> _mapDemoEventToState(event) async* {
  //   yield LoadingAuthState();
  //   try {
  //     await _repository.demoAuth();
  //     yield SuccessAuthState();
  //   } catch (error, stacktrace) {
  //     var errorData = json.decode(error.response.toString());
  //     yield* _errorToState(errorData['message']);
  //   }
  // }

  // Stream<AuthState> _mapSignInEventToState(event) async* {
  //   yield LoadingAuthState();
  //   try {
  //     await _repository.authUser(event.login, event.password);
  //     yield SuccessAuthState();
  //   } catch (error, stacktrace) {
  //     var errorData = json.decode(error.response.toString());

  //     yield* _errorToState(errorData['message']);
  //   }
  // }
}
