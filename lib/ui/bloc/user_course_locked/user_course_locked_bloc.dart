import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/repository/user_course_repository.dart';

import './bloc.dart';

class UserCourseLockedBloc
    extends Bloc<UserCourseLockedEvent, UserCourseLockedState> {
  final UserCourseRepository _repository;

  UserCourseLockedBloc(this._repository)
      : super(InitialUserCourseLockedState()) {
    on<FetchEvent>(
      (event, emit) async {
        try {
          var response = await _repository.getCourse(event.courseId);
          emit(LoadedUserCourseLockedState(response));
        } catch (e, s) {
          print(e);
          print(s);
        }
      },
    );
  }

  @override
  UserCourseLockedState get initialState => InitialUserCourseLockedState();

  @override
  Stream<UserCourseLockedState> mapEventToState(
    UserCourseLockedEvent event,
  ) async* {
    if (event is FetchEvent) {}
  }
}
