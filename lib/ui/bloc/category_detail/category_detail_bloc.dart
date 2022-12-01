import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterstudy_app/data/models/FinalResponse.dart';

import 'package:masterstudy_app/data/models/category.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';

import '../../../data/models/course/CourcesResponse.dart';
import './bloc.dart';

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final HomeRepository _homeRepository;
  final CoursesRepository _coursesRepository;

  CategoryDetailBloc(this._homeRepository, this._coursesRepository)
      : super(InitialCategoryDetailState()) {
    on<FetchEvent>((event, emit) async {
      emit(InitialCategoryDetailState());
      try {
        var categories = await _homeRepository.getCategories();
        var courses =
            await _coursesRepository.getCourses(categoryId: event.categoryId);
        List<CoursesBean> cBeans = (courses.courses ?? [])
            .takeWhile((value) => value != null)
            .map<CoursesBean>((e) => e!)
            .toList();
        emit(LoadedCategoryDetailState(categories, cBeans));
      } catch (error, stackTrace) {
        print(error);
        print(stackTrace);
        emit(ErrorCategoryDetailState(event.categoryId));
      }
    });
  }

  // @override
  // CategoryDetailState get initialState => InitialCategoryDetailState();

  // @override
  // Stream<CategoryDetailState> mapEventToState(
  //   CategoryDetailEvent event,
  // ) async* {
  //   if (event is FetchEvent) {
  //     yield InitialCategoryDetailState();
  //     try {
  //       var categories = await _homeRepository.getCategories();
  //       var courses =
  //           await _coursesRepository.getCourses(categoryId: event.categoryId);

  //       yield LoadedCategoryDetailState(categories, courses.courses);
  //     } catch (error, stackTrace) {
  //       print(error);
  //       print(stackTrace);
  //       yield ErrorCategoryDetailState(event.categoryId);
  //     }
  //   }
  // }
}
