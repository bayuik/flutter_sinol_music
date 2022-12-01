import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/cache/cache_manager.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import './bloc.dart';

class QuizLessonBloc extends Bloc<QuizLessonEvent, QuizLessonState> {
  final LessonRepository repository;
  final CacheManager cacheManager;

  QuizLessonBloc(this.repository, this.cacheManager)
      : super(InitialQuizLessonState()) {
    on<FetchEvent>(
      (event, emit) async {
        try {
          var response =
              await repository.getQuiz(event.courseId, event.lessonId);
          emit(LoadedQuizLessonState(response));
        } catch (error, s) {
          if (await cacheManager.isCached(event.courseId)) {
            emit(CacheWarningQuizLessonState());
          }
          print(error.toString() + "-" + s.toString());
        }
      },
    );
  }

  @override
  QuizLessonState get initialState => InitialQuizLessonState();

  @override
  Stream<QuizLessonState> mapEventToState(
    QuizLessonEvent event,
  ) async* {
    if (event is FetchEvent) {
      try {
        var response = await repository.getQuiz(event.courseId, event.lessonId);

        yield LoadedQuizLessonState(response);
      } catch (e, s) {
        if (await cacheManager.isCached(event.courseId)) {
          yield CacheWarningQuizLessonState();
        }
        print(e);
        print(s);
      }
    }
  }
}
