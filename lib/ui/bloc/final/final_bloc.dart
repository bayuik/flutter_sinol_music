import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/cache/cache_manager.dart';
import 'package:masterstudy_app/data/models/FinalResponse.dart';
import 'package:masterstudy_app/data/repository/final_repository.dart';

import './bloc.dart';

class FinalBloc extends Bloc<FinalEvent, FinalState> {
  final FinalRepository _finalRepository;
  final CacheManager cacheManager;

  FinalBloc(this._finalRepository, this.cacheManager)
      : super(InitialFinalState()) {
    on<FetchEvent>((event, emit) async {
      try {
        FinalResponse response =
            await _finalRepository.getCourseResults(event.courseId);

        print(response);

        emit(LoadedFinalState(response));
      } catch (error) {
        if (await cacheManager.isCached(event.courseId)) {
          emit(CacheWarningState());
        }
        print('Final Page Error');
        print(error);
      }
    });
  }

  @override
  FinalState get initialState => InitialFinalState();

  @override
  Stream<FinalState> mapEventToState(FinalEvent event) async* {
    if (event is FetchEvent) {
      try {
        FinalResponse response =
            await _finalRepository.getCourseResults(event.courseId);

        print(response);

        yield LoadedFinalState(response);
      } catch (error) {
        if (await cacheManager.isCached(event.courseId)) {
          yield CacheWarningState();
        }
        print('Final Page Error');
        print(error);
      }
    }
  }
}
