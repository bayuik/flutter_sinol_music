import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/models/course/CourcesResponse.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';

class SearchDetailBloc extends Bloc<SearchDetailEvent, SearchDetailState> {
  final CoursesRepository _coursesRepository;

  SearchDetailBloc(this._coursesRepository)
      : super(InitialSearchDetailState()) {
    on<FetchEvent>(
      (event, emit) async {
        if (event.query.isNotEmpty) {
          try {
            emit(LoadingSearchDetailState());
            CourcesResponse response =
                await _coursesRepository.getCourses(searchQuery: event.query);
            if (response.courses != null)
              emit(
                  LoadedSearchDetailState(response.courses!.getNonNullItems()));
          } catch (error, stacktrace) {
            print(error);
            print(stacktrace);
            emit(NotingFoundSearchDetailState());
          }
        }
      },
      transformer: (event, transtitionFn) => event
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(transtitionFn),
    );
  }

  // @override
  // SearchDetailState get initialState => InitialSearchDetailState();

  // @override
  // Stream<SearchDetailState> transformEvents(
  //   Stream<SearchDetailEvent> events,
  //   Stream<SearchDetailState> Function(SearchDetailEvent event) next,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(
  //       Duration(milliseconds: 500),
  //     ),
  //     next,
  //   );
  // }

  // @override
  // void onTransition(
  //     Transition<SearchDetailEvent, SearchDetailState> transition) {}

  // @override
  // Stream<SearchDetailState> mapEventToState(
  //   SearchDetailEvent event,
  // ) async* {}
}
