import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/models/course/CourseDetailResponse.dart';
import 'package:masterstudy_app/data/models/purchase/UserPlansResponse.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/repository/purchase_repository.dart';
import 'package:masterstudy_app/data/repository/review_respository.dart';

import './bloc.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CoursesRepository _coursesRepository;
  final ReviewRepository _reviewRepository;
  final PurchaseRepository _purchaseRepository;
  CourseDetailResponse? courseDetailResponse;
  List<UserPlansBean> availablePlans = [];

  // if payment id is -1, selected type is one time payment
  int selectedPaymetId = -1;

  CourseBloc(
    this._coursesRepository,
    this._reviewRepository,
    this._purchaseRepository,
  ) : super(InitialCourseState()) {
    on<FetchEvent>((event, emit) async {
      if (courseDetailResponse == null || state is ErrorCourseState)
        emit(InitialCourseState());
      try {
        courseDetailResponse =
            await _coursesRepository.getCourse(event.courseId);
        var reviews = await _reviewRepository.getReviews(event.courseId);
        var plans = await _purchaseRepository.getUserPlans();
        availablePlans = await _purchaseRepository.getPlans();
        if (courseDetailResponse != null) {
          emit(LoadedCourseState(courseDetailResponse!, reviews, plans));
        }
      } catch (e, s) {
        print(e);
        print(s);
        emit(ErrorCourseState());
      }
    });
    on<DeleteFromFavorite>((event, emit) async {
      try {
        await _coursesRepository.deleteFavoriteCourse(event.courseId);
        final courseId = event.courseId;
        this.add(FetchEvent(courseId));
      } catch (error) {
        print(error);
      }
    });
    on<AddToFavorite>((event, emit) async {
      try {
        await _coursesRepository.addFavoriteCourse(event.courseId);
        final courseId = event.courseId;
        this.add(FetchEvent(courseId));
      } catch (error) {
        print(error);
      }
    });
    on<VerifyInAppPurchase>(
      (event, emit) async {
        emit(InitialCourseState());
        try {
          await _coursesRepository.verifyInApp(
              event.serverVerificationData, event.price);
        } catch (error) {
          print(error);
        } finally {
          this.add(FetchEvent(event.courseId));
          // emit(_fetchCourse(event.courseId));
        }
      },
    );
    on<PaymentSelectedEvent>(
      (event, emit) {
        selectedPaymetId = event.selectedPaymentId;
        this.add(FetchEvent(event.courseId));
      },
    );
    on<UsePlan>(
      (event, emit) async {
        emit(InitialCourseState());
        await _purchaseRepository.usePlan(event.courseId, selectedPaymetId);
        this.add(FetchEvent(event.courseId));
      },
    );
    on<AddToCart>(
      (event, emit) async {
        var response = await _purchaseRepository.addToCart(event.courseId);
        if (response.cart_url != null) {
          emit(OpenPurchaseState(response.cart_url!));
        }
      },
    );
  }

  @override
  Stream<CourseState> mapEventToState(
    CourseEvent event,
  ) async* {
    // if (event is FetchEvent) {
    //   yield* _mapFetchToState(event);
    // }
    // if (event is DeleteFromFavorite) {
    //   yield* _mapDeleteFavToState(event);
    // }
    // if (event is AddToFavorite) {
    //   yield* _mapAddFavToState(event);
    // }
    // if (event is VerifyInAppPurchase) {
    //   yield* _mapVerifyInAppToState(event);
    // }

    // if (event is PaymentSelectedEvent) {
    //   selectedPaymetId = event.selectedPaymentId;
    //   _fetchCourse(event.courseId);
    // }

    // if (event is UsePlan) {
    //   yield InitialCourseState();
    //   await _purchaseRepository.usePlan(event.courseId, selectedPaymetId);

    //   yield* _fetchCourse(event.courseId);
    // }

    // if (event is AddToCart) {
    //   var response = await _purchaseRepository.addToCart(event.courseId);
    //   yield OpenPurchaseState(response.cart_url);
    //   //yield* _fetchCourse(event.courseId);
    // }
  }

  Stream<CourseState> _fetchCourse(courseId) async* {
    // if (courseDetailResponse == null || state is ErrorCourseState)
    //   yield InitialCourseState();
    // try {
    //   courseDetailResponse = await _coursesRepository.getCourse(courseId);
    //   var reviews = await _reviewRepository.getReviews(courseId);
    //   var plans = await _purchaseRepository.getUserPlans();
    //   availablePlans = await _purchaseRepository.getPlans();
    //   yield LoadedCourseState(courseDetailResponse, reviews, plans);
    // } catch (e, s) {
    //   print(e);
    //   print(s);
    //   yield ErrorCourseState();
    // }
  }

  Stream<CourseState> _mapFetchToState(FetchEvent event) async* {
    yield* _fetchCourse(event.courseId);
  }

  Stream<CourseState> _mapVerifyInAppToState(VerifyInAppPurchase event) async* {
    yield InitialCourseState();
    try {
      await _coursesRepository.verifyInApp(
          event.serverVerificationData, event.price);
    } catch (error) {
      print(error);
    } finally {
      yield* _fetchCourse(event.courseId);
    }
  }

  Stream<CourseState> _mapAddFavToState(event) async* {
    try {
      await _coursesRepository.addFavoriteCourse(event.courseId);
      yield* _fetchCourse(event.courseId);
    } catch (error) {
      print(error);
    }
  }

  Stream<CourseState> _mapDeleteFavToState(event) async* {
    try {
      await _coursesRepository.deleteFavoriteCourse(event.courseId);
      yield* _fetchCourse(event.courseId);
    } catch (error) {
      print(error);
    }
  }
}
