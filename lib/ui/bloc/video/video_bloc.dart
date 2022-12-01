import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(InitialVideoState()) {
    on((event, emit) {
      emit(LoadedVideoState());
    });
  }

  @override
  VideoState get initialState => InitialVideoState();

  @override
  Stream<VideoState> mapEventToState(
    VideoEvent event,
  ) async* {
    yield LoadedVideoState();
  }
}
