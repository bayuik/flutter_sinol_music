import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/repository/courses_repository.dart';

import './bloc.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final CoursesRepository coursesRepository;

  FavoritesBloc(this.coursesRepository) : super(InitialFavoritesState()) {
    on<FetchFavorites>((event, emit) async {
      if (state is ErrorFavoritesState) emit(InitialFavoritesState());
      try {
        var courses = await coursesRepository.getFavoriteCourses();
        if ((courses.courses ?? []).isNotEmpty) {
          emit(LoadedFavoritesState(courses.courses!
              .takeWhile((value) => value != null)
              .map((e) => e!)
              .toList()));
        } else {
          emit(EmptyFavoritesState());
        }
      } catch (_) {
        emit(ErrorFavoritesState());
      }
    });
    on<DeleteEvent>((event, emit) async {
      try {
        var courses = (state as LoadedFavoritesState).favoriteCourses;
        courses.removeWhere((item) => item.id == event.courseId);
        await coursesRepository.deleteFavoriteCourse(event.courseId);
        emit(LoadedFavoritesState(courses));
      } catch (_) {}
    });
  }

  // @override
  // FavoritesState get initialState => InitialFavoritesState();

  // @override
  // Stream<FavoritesState> mapEventToState(
  //   FavoritesEvent event,
  // ) async* {
  //   if (event is FetchFavorites) {
  //     yield* _mapFetchToState();
  //   }
  //   if (event is DeleteEvent) {
  //     yield* _mapDeleteToState(event);
  //   }
  // }

  // Stream<FavoritesState> _mapFetchToState() async* {
  //   if (state is ErrorFavoritesState) yield InitialFavoritesState();
  //   try {
  //     var courses = await coursesRepository.getFavoriteCourses();
  //     if (courses.courses.isNotEmpty) {
  //       yield LoadedFavoritesState(courses.courses);
  //     } else {
  //       yield EmptyFavoritesState();
  //     }
  //   } catch (_) {
  //     yield ErrorFavoritesState();
  //   }
  // }

  // Stream<FavoritesState> _mapDeleteToState(event) async* {
  //   try {
  //     var courses = (state as LoadedFavoritesState).favoriteCourses;
  //     courses.removeWhere((item) => item.id == event.courseId);
  //     await coursesRepository.deleteFavoriteCourse(event.courseId);
  //     yield LoadedFavoritesState(courses);
  //   } catch (_) {}
  // }
}
