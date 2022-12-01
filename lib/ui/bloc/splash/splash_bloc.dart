import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/models/AppSettings.dart';
import 'package:masterstudy_app/data/network/api_provider.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';
import 'package:masterstudy_app/main.dart';

import './bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _repository;
  final HomeRepository _homeRepository;
  final UserApiProvider _apiProvider;

  SplashBloc(this._repository, this._homeRepository, this._apiProvider)
      : super(InitialSplashState()) {
    on((event, emit) async {
      if (event is CheckAuthSplashEvent) {
        bool signed = await _repository.isSigned();
        emit(InitialSplashState());
        try {
          AppSettings appSettings = await _homeRepository.getAppSettings();
          try {
            var locale = await _apiProvider.getLocalization();
            localizations.saveCustomLocalization(locale);
          } catch (e) {}

          emit(CloseSplash(signed, appSettings));
        } catch (e, s) {
          emit(CloseSplash(signed, null));

          print(e);
          print(s);
          //yield ErrorSplashState();
        }
      }
    });
  }

  @override
  // SplashState get initialState => ;

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {}
}
