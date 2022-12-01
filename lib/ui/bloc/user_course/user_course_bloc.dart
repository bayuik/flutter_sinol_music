import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/cache/cache_manager.dart';
import 'package:masterstudy_app/data/models/CachedCourse.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';
import 'package:masterstudy_app/data/utils.dart';

import './bloc.dart';

class UserCourseBloc extends Bloc<UserCourseEvent, UserCourseState> {
  final UserCourseRepository _repository;
  final LessonRepository _lessonsRepository;
  final CacheManager cacheManager;

  UserCourseBloc(this._repository, this.cacheManager, this._lessonsRepository)
      : super(InitialUserCourseState()) {
    on((event, emit) async {
      if (event is FetchEvent) {
        int courseId = int.parse(event.userCourseScreenArgs.course_id ?? '0');

        var isCached = await cacheManager.isCached(courseId);
        if (state is ErrorUserCourseState) emit(InitialUserCourseState());
        try {
          var response = await _repository.getCourseCurriculum(courseId);

          emit(LoadedUserCourseState(
              (response.sections ?? []).getNonNullItems(),
              response.progress_percent ?? "0",
              response.current_lesson_id ?? "",
              response.lesson_type ?? "",
              response = response,
              await cacheManager.isCached(courseId),
              false));
          if (isCached) {
            print(event.userCourseScreenArgs.postsBean?.hash);
            var currentHash = (await cacheManager.getFromCache())
                ?.courses
                ?.firstWhere((element) => courseId == element?.id)
                ?.hash;
            print(currentHash);
            if (event.userCourseScreenArgs.postsBean?.hash !=
                (await cacheManager.getFromCache())
                    ?.courses
                    ?.firstWhere((element) => courseId == element?.id)
                    ?.hash) {
              if (state is LoadedUserCourseState) {
                var state = this.state as LoadedUserCourseState;
                emit(LoadedUserCourseState(
                    state.sections,
                    state.progress,
                    state.current_lesson_id,
                    state.lesson_type,
                    state.response,
                    false,
                    true));
                try {
                  CachedCourse course = CachedCourse(
                      id: int.parse(
                          event.userCourseScreenArgs.course_id ?? '0'),
                      postsBean: event.userCourseScreenArgs.postsBean!
                        ..fromCache = true,
                      curriculumResponse: (state).response,
                      hash: event.userCourseScreenArgs.hash);

                  var sections =
                      (state).response.sections?.map((e) => e?.section_items);
                  List<int> iDs = [];
                  sections?.forEach((element) {
                    element?.forEach((element) {
                      if (element?.item_id != null) {
                        iDs.add(element!.item_id!);
                      }
                    });
                  });
                  print(iDs.length);
                  course.lessons = await _lessonsRepository.getAllLessons(
                      int.parse(event.userCourseScreenArgs.course_id ?? '0'),
                      iDs);
                  await cacheManager.writeToCache(course);
                  emit(LoadedUserCourseState(
                      state.sections,
                      state.progress,
                      state.current_lesson_id,
                      state.lesson_type,
                      state.response,
                      true,
                      false));
                } catch (e, s) {
                  print(e);
                  print(s);
                  emit(LoadedUserCourseState(
                      state.sections,
                      state.progress,
                      state.current_lesson_id,
                      state.lesson_type,
                      state.response,
                      false,
                      false));
                }
              }
            }
          }
        } catch (e, s) {
          if (isCached) {
            var cache = await cacheManager.getFromCache();

            if (cache?.courses
                    ?.firstWhere((element) => courseId == element?.id) !=
                null) {
              print("sesh");
              var response = cache?.courses
                  ?.firstWhere((element) => courseId == element?.id)
                  ?.curriculumResponse;
              if (response != null) {
                emit(
                  LoadedUserCourseState(
                    (response.sections ?? []).getNonNullItems(),
                    response.progress_percent ?? "0",
                    response.current_lesson_id ?? "",
                    response.lesson_type ?? "",
                    response = response,
                    true,
                    false,
                  ),
                );
              }
            } else {
              emit(ErrorUserCourseState());
            }
          } else {
            emit(ErrorUserCourseState());
          }

          print(e);
          print(s);
        }
      }
      if (event is CacheCourseEvent) {
        if (state is LoadedUserCourseState) {
          var state = this.state as LoadedUserCourseState;
          emit(LoadedUserCourseState(
              state.sections,
              state.progress,
              state.current_lesson_id,
              state.lesson_type,
              state.response,
              false,
              true));
          try {
            CachedCourse course = CachedCourse(
                id: int.parse(event.userCourseScreenArgs.course_id ?? '0'),
                postsBean: event.userCourseScreenArgs.postsBean!
                  ..fromCache = true,
                curriculumResponse: (state).response,
                hash: event.userCourseScreenArgs.hash);

            var sections =
                (state).response.sections?.map((e) => e?.section_items);
            List<int> iDs = [];
            sections?.forEach((element) {
              element?.forEach((element) {
                if (element?.item_id != null) {
                  iDs.add(element!.item_id!);
                }
              });
            });
            print(iDs.length);
            course.lessons = await _lessonsRepository.getAllLessons(
                int.parse(event.userCourseScreenArgs.course_id ?? '0'), iDs);
            await cacheManager.writeToCache(course);
            emit(state);
          } catch (e, s) {
            print(e);
            print(s);
            emit(LoadedUserCourseState(
                state.sections,
                state.progress,
                state.current_lesson_id,
                state.lesson_type,
                state.response,
                false,
                false));
          }
        }
      }
    });
  }

  @override
  UserCourseState get initialState => InitialUserCourseState();

  @override
  Stream<UserCourseState> mapEventToState(
    UserCourseEvent event,
  ) async* {}

  Stream<UserCourseState> mapCacheCourseEventToState(
      CacheCourseEvent event) async* {}
}
