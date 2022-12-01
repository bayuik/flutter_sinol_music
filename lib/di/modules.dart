import 'package:dio/dio.dart';
// import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
//
import 'package:injectable/injectable.dart';
import 'package:masterstudy_app/data/cache/cache_manager.dart';
import 'package:masterstudy_app/data/network/api_provider.dart';
import 'package:masterstudy_app/data/network/interceptors/interceptor.dart';
import 'package:masterstudy_app/data/network/interceptors/loggining_interceptor.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:masterstudy_app/data/repository/assignment_repository.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:masterstudy_app/data/repository/courses_repository.dart';
import 'package:masterstudy_app/data/repository/home_repository.dart';
import 'package:masterstudy_app/data/repository/instructors_repository.dart';
import 'package:masterstudy_app/data/repository/lesson_repository.dart';
import 'package:masterstudy_app/data/repository/purchase_repository.dart';
import 'package:masterstudy_app/data/repository/review_respository.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';
import 'package:masterstudy_app/data/repository/questions_repository.dart';
import 'package:masterstudy_app/data/repository/final_repository.dart';
import 'package:masterstudy_app/ui/bloc/auth/auth_bloc.dart';
import 'package:masterstudy_app/ui/bloc/quiz_screen/bloc.dart';
import 'package:masterstudy_app/ui/bloc/splash/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
class AppModule {
  @singleton
  AuthRepository userRepository(
          UserApiProvider apiProvider, SharedPreferences sharedPreferences) =>
      new AuthRepositoryImpl(apiProvider, sharedPreferences);

  @singleton
  HomeRepository homeRepository(
          UserApiProvider apiProvider, SharedPreferences sharedPreferences) =>
      new HomeRepositoryImpl(apiProvider, sharedPreferences);

  @singleton
  CoursesRepository coursesRepository(UserApiProvider apiProvider) =>
      new CoursesRepositoryImpl(apiProvider);

  @singleton
  InstructorsRepository instructorsRepository(UserApiProvider apiProvider) =>
      new InstructorsRepositoryImpl(apiProvider);

  @singleton
  ReviewRepository reviewRepository(UserApiProvider apiProvider) =>
      new ReviewRepositoryImpl(apiProvider);

  @singleton
  AssignmentRepository assignmentRepository(UserApiProvider apiProvider) =>
      new AssignmentRepositoryImpl(apiProvider);

  @singleton
  QuestionsRepository questionsRepository(UserApiProvider apiProvider) =>
      new QuestionsRepositoryImpl(apiProvider);

  @singleton
  FinalRepository finalRepository(UserApiProvider apiProvider) =>
      new FinalRepositoryImpl(apiProvider);

  @singleton
  UserApiProvider provideUserApiProvider(Dio dio) => new UserApiProvider(dio);

  @singleton
  Dio provideDio() {
    var dio = Dio();
    dio.interceptors.add(AppInterceptors());
    dio.interceptors.add(LoggingInterceptors());
    // dio.transformer = FlutterTransformer();
    return dio;
  }

  @singleton
  @factoryMethod
  Future<SharedPreferences> provideSharedPreferences() async =>
      await SharedPreferences.getInstance();

  AuthBloc provideAuthBloc(AuthRepository repository) =>
      new AuthBloc(repository);

  AccountRepository provideAccountRepository(UserApiProvider apiProvider) =>
      new AccountRepositoryImpl(apiProvider);

  UserCourseRepository provideUserCourseRepository(
          UserApiProvider apiProvider, CacheManager cacheManager) =>
      new UserCourseRepositoryImpl(apiProvider, cacheManager);

  LessonRepository provideLessonRepository(
          UserApiProvider apiProvider, CacheManager manager) =>
      new LessonRepositoryImpl(apiProvider, manager);

  SplashBloc provideSplashBloc(AuthRepository repository,
          HomeRepository homeRepository, UserApiProvider apiProvider) =>
      new SplashBloc(repository, homeRepository, apiProvider);

  QuizScreenBloc provideQuizScreenBloc(LessonRepository repository) =>
      new QuizScreenBloc(repository);

  PurchaseRepository providePurchaseRepository(UserApiProvider apiProvider) =>
      new PurchaseRepositoryImpl(apiProvider);
}
