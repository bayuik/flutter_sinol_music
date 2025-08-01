import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/cache/cache_manager.dart';
import 'package:masterstudy_app/data/models/AssignmentResponse.dart';
import 'package:masterstudy_app/data/repository/assignment_repository.dart';

import './bloc.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentRepository _assignmentRepository;
  final CacheManager cacheManager;

  AssignmentBloc(this._assignmentRepository, this.cacheManager)
      : super(InitialAssignmentState()) {
    on<FetchEvent>((event, emit) async {
      try {
        AssignmentResponse assignment = await _assignmentRepository
            .getAssignmentInfo(event.courseId, event.assignmentId);

        emit(LoadedAssignmentState(assignment));
      } catch (error) {
        if (await cacheManager.isCached(event.courseId)) {
          emit(CacheWarningAssignmentState());
        }
        print(error);
      }
    });
    on<StartAssignmentEvent>((event, emit) async {
      try {
        var assignmentStart = await _assignmentRepository.startAssignment(
            event.courseId, event.assignmentId);
        AssignmentResponse assignment = await _assignmentRepository
            .getAssignmentInfo(event.courseId, event.assignmentId);

        emit(LoadedAssignmentState(assignment));
      } catch (error) {
        print(error);
      }
    });
    on<AddAssignmentEvent>(
      (event, emit) async {
        try {
          int course_id = event.courseId;
          int user_assignment_id = event.userAssignmentId;
          if (event.files.isNotEmpty) {
            event.files.forEach((elem) {
              var uploadFile = _assignmentRepository.uploadAssignmentFile(
                  course_id, user_assignment_id, elem);
              print(uploadFile);
            });
          }

          var assignmentAdd = await _assignmentRepository.addAssignment(
              event.courseId, event.userAssignmentId, event.content);

          AssignmentResponse assignment = await _assignmentRepository
              .getAssignmentInfo(event.courseId, event.assignmentId);

          emit(LoadedAssignmentState(assignment));
        } catch (error) {
          print(error);
        }
      },
    );
  }

  @override
  Stream<AssignmentState> mapEventToState(AssignmentEvent event) async* {
    if (event is FetchEvent) {}

    if (event is StartAssignmentEvent) {}

    if (event is AddAssignmentEvent) {}
  }
}
