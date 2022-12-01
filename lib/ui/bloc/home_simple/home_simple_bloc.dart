import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/utils.dart';

import './bloc.dart';

class HomeSimpleBloc extends Bloc<HomeSimpleEvent, HomeSimpleState> {
  final CoursesRepository _coursesRepository;

  HomeSimpleBloc(this._coursesRepository) : super(InitialHomeSimpleState()) {
    on<FetchHomeSimpleEvent>(
      (event, emit) async {
        try {
          var coursesNew =
              await _coursesRepository.getCourses(sort: Sort.date_low);

          emit(
            LoadedHomeSimpleState(
              (coursesNew.courses ?? []).getNonNullItems(),
            ),
          );
        } catch (error, stackTrace) {
          print(error);
          print(stackTrace);
        }
      },
    );
  }

  @override
  HomeSimpleState get initialState => InitialHomeSimpleState();

  // @override
  // Stream<HomeSimpleState> mapEventToState(
  //   HomeSimpleEvent event,
  // ) async* {
  //   if (event is FetchHomeSimpleEvent) {
  //     try {
  //       var coursesNew =
  //           await _coursesRepository.getCourses(sort: Sort.date_low);

  //       yield LoadedHomeSimpleState(coursesNew.courses);
  //     } catch (error, stackTrace) {
  //       print(error);
  //       print(stackTrace);
  //     }
  //   }
  // }
}
