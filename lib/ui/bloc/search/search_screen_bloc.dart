import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/models/course/CourcesResponse.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/utils.dart';

import './bloc.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  SearchScreenBloc(this._coursesRepository)
      : super(InitialSearchScreenState()) {
    on<FetchEvent>((event, emit) async {
      if (state is ErrorSearchScreenState) emit(InitialSearchScreenState());
      if (_popularSearches.isEmpty || _newCourses.isEmpty) {
        emit(InitialSearchScreenState());
        try {
          _newCourses =
              ((await _coursesRepository.getCourses(sort: Sort.date_low))
                          .courses ??
                      [])
                  .getNonNullItems();
          _popularSearches =
              ((await _coursesRepository.getPopularSearches()).searches ?? [])
                  .getNonNullItems();
          emit(LoadedSearchScreenState(_newCourses, _popularSearches));
        } catch (_) {
          emit(ErrorSearchScreenState());
        }
      }
    });
  }

  // @override
  // SearchScreenState get initialState => InitialSearchScreenState();

  final CoursesRepository _coursesRepository;
  List<String> _popularSearches = [];
  List<CoursesBean> _newCourses = [];

  @override
  Stream<SearchScreenState> mapEventToState(
    SearchScreenEvent event,
  ) async* {
    if (event is FetchEvent) {
      yield* _mapFetchToState();
    }
  }

  Stream<SearchScreenState> _mapFetchToState() async* {}
}
