import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class ProfileAssignmentBloc
    extends Bloc<ProfileAssignmentEvent, ProfileAssignmentState> {
  ProfileAssignmentBloc() : super(InitialProfileAssignmentState()) {}

  @override
  ProfileAssignmentState get initialState => InitialProfileAssignmentState();

  @override
  Stream<ProfileAssignmentState> mapEventToState(
    ProfileAssignmentEvent event,
  ) async* {}
}
