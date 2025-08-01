import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/models/QuestionAddResponse.dart';
import 'package:masterstudy_app/data/models/QuestionsResponse.dart';
import 'package:masterstudy_app/data/repository/questions_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './bloc.dart';

class QuestionDetailsBloc
    extends Bloc<QuestionDetailsEvent, QuestionDetailsState> {
  final QuestionsRepository _questionsRepository;

  QuestionDetailsBloc(this._questionsRepository)
      : super(InitialQuestionDetailsState()) {
    on<QuestionAddEvent>(
      (event, emit) async {
        try {
          emit(ReplyAddingState());
          QuestionAddResponse addAnswer =
              await _questionsRepository.addQuestion(
            event.lessonId,
            event.comment,
            event.parent,
          );
          emit(ReplyAddedState(addAnswer));
        } catch (error) {
          print(error);
        }

        emit(LoadedQuestionDetailsState());
      },
    );
  }

  @override
  QuestionDetailsState get initialState => InitialQuestionDetailsState();

  @override
  Stream<QuestionDetailsState> mapEventToState(
      QuestionDetailsEvent event) async* {
    if (event is QuestionAddEvent) {
      try {
        yield ReplyAddingState();
        QuestionAddResponse addAnswer = await _questionsRepository.addQuestion(
            event.lessonId, event.comment, event.parent);
        yield ReplyAddedState(addAnswer);
      } catch (error) {
        print(error);
      }
    }

    yield LoadedQuestionDetailsState();
  }
}
