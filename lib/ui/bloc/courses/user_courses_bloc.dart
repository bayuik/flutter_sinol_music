import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/cache/cache_manager.dart';
import 'package:masterstudy_app/data/models/user_course.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';

import './bloc.dart';

class UserCoursesBloc extends Bloc<UserCoursesEvent, UserCoursesState> {
  UserCoursesBloc(this._userCourseRepository, this._cacheManager)
      : super(InitialUserCoursesState()) {
    on<FetchEvent>(
      (event, emit) async {
        if (state is ErrorUserCoursesState) emit(InitialUserCoursesState());
        try {
          UserCourseResponse response =
              await _userCourseRepository.getUserCourses();
          if (response.posts.isEmpty) {
            emit(EmptyCoursesState());
          } else {
            emit(InitialUserCoursesState());
            emit(LoadedCoursesState(response.posts
                .takeWhile((value) => value != null)
                .map<PostsBean>((e) => e!..fromCache = false)
                .toList()));
            print(response.posts.length);
          }
        } catch (e, s) {
          print(e);
          print(s);
          var cache = await _cacheManager.getFromCache();
          if (cache != null) {
            try {
              List<PostsBean> list = [];
              cache.courses?.forEach((element) {
                if (element != null && element.postsBean != null) {
                  list.add(element.postsBean!..fromCache = true);
                }
              });
              emit(LoadedCoursesState(list));
            } catch (e, s) {
              print(e);
              print(s);
              emit(ErrorUserCoursesState());
            }
          } else {
            emit(ErrorUserCoursesState());
          }
        }
      },
    );
  }

  // @override
  // UserCoursesState get initialState => InitialUserCoursesState();

  final UserCourseRepository _userCourseRepository;
  final CacheManager _cacheManager;

  // @override
  // Stream<UserCoursesState> mapEventToState(
  //   UserCoursesEvent event,
  // ) async* {
  //   if (event is FetchEvent) {
  //     yield* _mapFetchToState();
  //   }
  // }

  // Stream<UserCoursesState> _mapFetchToState() async* {
  //   if (state is ErrorUserCoursesState) yield InitialUserCoursesState();
  //   try {
  //     UserCourseResponse response =
  //         await _userCourseRepository.getUserCourses();
  //     if (response.posts.isEmpty) {
  //       yield EmptyCoursesState();
  //     } else {
  //       yield InitialUserCoursesState();
  //       yield LoadedCoursesState(response.posts
  //           .takeWhile((value) => value != null)
  //           .map<PostsBean>((e) => e!..fromCache = false)
  //           .toList());
  //       print(response.posts.length);
  //     }
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //     var cache = await _cacheManager.getFromCache();
  //     if (cache != null) {
  //       try {
  //         List<PostsBean> list = List();
  //         cache.courses.forEach((element) {
  //           list.add(element.postsBean..fromCache = true);
  //         });
  //         yield LoadedCoursesState(list);
  //       } catch (e, s) {
  //         print(e);
  //         print(s);
  //         yield ErrorUserCoursesState();
  //       }
  //     } else {
  //       yield ErrorUserCoursesState();
  //     }
  //   }
  // }
}
