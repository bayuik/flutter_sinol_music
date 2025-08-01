import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';
import 'package:masterstudy_app/data/repository/instructors_repository.dart';

import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final CoursesRepository _coursesRepository;
  final InstructorsRepository _instructorsRepository;

  HomeBloc(this._homeRepository, this._coursesRepository,
      this._instructorsRepository)
      : super(InitialHomeState()) {
    on<FetchEvent>(
      (event, emit) async {
        if (state is ErrorHomeState) emit(InitialHomeState());
        try {
          var layouts = (await _homeRepository.getAppSettings()).home_layout;

          layouts?.removeWhere((element) => element?.enabled == false);

          var categories = await _homeRepository.getCategories();
          var coursesFree =
              await _coursesRepository.getCourses(sort: Sort.free);
          var coursesNew =
              await _coursesRepository.getCourses(sort: Sort.date_low);
          var coursesTrending =
              await _coursesRepository.getCourses(sort: Sort.rating);

          var instructors = await _instructorsRepository
              .getInstructors(InstructorsSort.rating);

          emit(
            LoadedHomeState(
              categories,
              (coursesTrending.courses ?? []).getNonNullItems(),
              (layouts ?? []).getNonNullItems(),
              (coursesNew.courses ?? []).getNonNullItems(),
              (coursesFree.courses ?? []).getNonNullItems(),
              (instructors).getNonNullItems(),
            ),
          );
        } catch (error, stacktrace) {
          print(error);
          print(stacktrace);
          emit(ErrorHomeState());
        }
      },
    );
  }

  // @override
  // HomeState get initialState => InitialHomeState();

  // @override
  // Stream<HomeState> mapEventToState(
  //   HomeEvent event,
  // ) async* {
  //   if (event is FetchEvent) {
  //     if (state is ErrorHomeState) yield InitialHomeState();
  //     try {
  //       var layouts = (await _homeRepository.getAppSettings()).home_layout;

  //       layouts.removeWhere((element) => element.enabled == false);

  //       var categories = await _homeRepository.getCategories();
  //       var coursesFree = await _coursesRepository.getCourses(sort: Sort.free);
  //       var coursesNew =
  //           await _coursesRepository.getCourses(sort: Sort.date_low);
  //       var coursesTrending =
  //           await _coursesRepository.getCourses(sort: Sort.rating);

  //       var instructors =
  //           await _instructorsRepository.getInstructors(InstructorsSort.rating);

  //       yield LoadedHomeState(categories, coursesTrending.courses, layouts,
  //           coursesNew.courses, coursesFree.courses, instructors);
  //     } catch (error, stacktrace) {
  //       print(error);
  //       print(stacktrace);
  //       yield ErrorHomeState();
  //     }
  //   }
  // }
}
