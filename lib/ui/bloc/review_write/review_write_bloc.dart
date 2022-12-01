import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/models/ReviewAddResponse.dart';
import 'package:masterstudy_app/data/models/account.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:masterstudy_app/data/repository/review_respository.dart';

import './bloc.dart';

class ReviewWriteBloc extends Bloc<ReviewWriteEvent, ReviewWriteState> {
  final AccountRepository _accountRepository;
  final ReviewRepository _reviewRepository;
  late Account accountObj;

  ReviewWriteBloc(this._accountRepository, this._reviewRepository)
      : super(InitialReviewWriteState()) {
    on<SaveReviewEvent>((event, emit) async {
      try {
        ReviewAddResponse reviewAddResponse = await _reviewRepository.addReview(
            event.id, event.mark, event.review);

        emit(ReviewResponseState(reviewAddResponse, accountObj));
      } catch (error) {
        print(error);
      }
    });
    on<FetchEvent>(
      (event, emit) async {
        try {
          Account account = await _accountRepository.getUserAccount();
          accountObj = account;
          emit(LoadedReviewWriteState(account));
        } catch (error) {
          print('Account resp error');
          print(error);
        }
      },
    );
  }

  @override
  ReviewWriteState get initialState => InitialReviewWriteState();

  @override
  Stream<ReviewWriteState> mapEventToState(ReviewWriteEvent event) async* {
    if (event is SaveReviewEvent) {
      yield* _mapEventAddReview(event);
    }

    if (event is FetchEvent) {}
  }

  @override
  Stream<ReviewWriteState> _mapEventAddReview(event) async* {}
}
