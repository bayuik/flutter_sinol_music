import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/repository/lesson_repository.dart';

import './bloc.dart';

class QuizScreenBloc extends Bloc<QuizScreenEvent, QuizScreenState> {
  final LessonRepository _repository;

  QuizScreenBloc(this._repository) : super(InitialQuizScreenState()) {
    on<FetchEvent>((event, emit) async {
      try {
        if (event.quizResponse != null)
          emit(LoadedQuizScreenState(event.quizResponse));
        var response =
            await _repository.getLesson(event.courseId, event.lessonId);
        if (response != null) {
          emit(LoadedQuizScreenState(response));
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
    });
  }

  @override
  QuizScreenState get initialState => InitialQuizScreenState();

  @override
  Stream<QuizScreenState> mapEventToState(
    QuizScreenEvent event,
  ) async* {
    // if (event is FetchEvent) {
    //   try {
    //     if (event.quizResponse != null)
    //       yield LoadedQuizScreenState(event.quizResponse);
    //     var response =
    //         await _repository.getLesson(event.courseId, event.lessonId);
    //     yield LoadedQuizScreenState(response);
    //   } catch (e, s) {
    //     print(e);
    //     print(s);
    //   }
    // }
  }
}
