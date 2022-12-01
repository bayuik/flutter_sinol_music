import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/models/LessonResponse.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import './bloc.dart';

class LessonVideoBloc extends Bloc<LessonVideoEvent, LessonVideoState> {
  final LessonRepository _lessonRepository;
  RegExp _regExp = RegExp(
      r"(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?",
      caseSensitive: false);
  String? extractYoutubeLink(String htmlContent) {
    var match = _regExp.firstMatch(htmlContent);
    if (match != null) {
      return match.group(0)?.replaceAll('"', '').trim();
    }
    return null;
  }

  LessonVideoBloc(this._lessonRepository) : super(InitialLessonVideoState()) {
    on<DisposeEvent>((event, emit) {
      if (state is LoadedLessonVideoState) {
        (state as LoadedLessonVideoState).disposeController();
      }
    });
    on<FetchEvent>(
      (event, emit) async {
        try {
          LessonResponse? response =
              await _lessonRepository.getLesson(event.courseId, event.lessonId);
          if (response != null) {
            var stateNew = LoadedLessonVideoState(response);
            stateNew.setController(YoutubePlayerController(
              initialVideoId:
                  extractYoutubeLink(stateNew.lessonResponse.content ?? "")
                          ?.split("/")
                          .last ??
                      "",
              flags: YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              ),
            ));
            emit(stateNew);
          }
        } catch (error) {
          print(error);
        }
      },
    );
    on<CompleteLessonEvent>(
      (event, emit) async {
        try {
          var response = await _lessonRepository.completeLesson(
            event.courseId,
            event.lessonId,
          );
        } catch (e, s) {
          print(e);
          print(s);
        }
      },
    );
  }

  @override
  LessonVideoState get initialState => InitialLessonVideoState();

  @override
  Stream<LessonVideoState> mapEventToState(
    LessonVideoEvent event,
  ) async* {
    if (event is FetchEvent) {
      // try {
      //   LessonResponse response =
      //       await _lessonRepository.getLesson(event.courseId, event.lessonId);

      //   yield LoadedLessonVideoState(response);
      // } catch (error) {
      //   print(error);
      // }
    } else if (event is CompleteLessonEvent) {
      // try {
      //   var response = await _lessonRepository.completeLesson(
      //       event.courseId, event.lessonId);
      // } catch (e, s) {
      //   print(e);
      //   print(s);
      // }
    }
  }
}
