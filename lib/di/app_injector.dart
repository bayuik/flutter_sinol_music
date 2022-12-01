import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:masterstudy_app/data/repository/final_repository.dart';
import 'package:masterstudy_app/data/repository/purchase_repository.dart';
import 'package:masterstudy_app/data/repository/questions_repository.dart';
import 'package:masterstudy_app/data/repository/review_respository.dart';
import 'package:masterstudy_app/data/repository/user_course_repository.dart';
import 'package:masterstudy_app/di/modules.dart';
import 'package:masterstudy_app/ui/bloc/auth/bloc.dart';
import 'package:masterstudy_app/ui/bloc/splash/bloc.dart';
import 'package:masterstudy_app/ui/screen/auth/auth_screen.dart';
import 'package:masterstudy_app/ui/screen/home/home_screen.dart';
import 'package:masterstudy_app/ui/screen/splash/splash_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cache/cache_manager.dart';
import '../data/network/api_provider.dart';
import '../data/network/interceptors/interceptor.dart';
import '../data/network/interceptors/loggining_interceptor.dart';
import '../data/repository/courses_repository.dart';
import '../data/repository/home_repository.dart';
import '../data/repository/instructors_repository.dart';
import '../data/repository/lesson_repository.dart';
import '../main.dart';
import '../ui/bloc/assignment/assignment_bloc.dart';
import '../ui/bloc/category_detail/bloc.dart';
import '../ui/bloc/course/bloc.dart';
import '../ui/bloc/courses/bloc.dart';
import '../ui/bloc/detail_profile/bloc.dart';
import '../ui/bloc/edit_profile_bloc/bloc.dart';
import '../ui/bloc/favorites/bloc.dart';
import '../ui/bloc/final/bloc.dart';
import '../ui/bloc/home/bloc.dart';
import '../ui/bloc/home_simple/bloc.dart';
import '../ui/bloc/lesson_stream/bloc.dart';
import '../ui/bloc/lesson_video/bloc.dart';
import '../ui/bloc/orders/bloc.dart';
import '../ui/bloc/plans/bloc.dart';
import '../ui/bloc/profile/bloc.dart';
import '../ui/bloc/profile_assignment/bloc.dart';
import '../ui/bloc/question_ask/bloc.dart';
import '../ui/bloc/question_details/bloc.dart';
import '../ui/bloc/questions/bloc.dart';
import '../ui/bloc/quiz_lesson/bloc.dart';
import '../ui/bloc/quiz_screen/bloc.dart';
import '../ui/bloc/restore_password/bloc.dart';
import '../ui/bloc/review_write/bloc.dart';
import '../ui/bloc/search/bloc.dart';
import '../ui/bloc/search_detail/bloc.dart';
import '../ui/bloc/text_lesson/bloc.dart';
import '../ui/bloc/user_course/bloc.dart';
import '../ui/bloc/user_course_locked/bloc.dart';
import '../ui/bloc/video/bloc.dart';
import 'app_injector.inject.dart' as g;

// @Injector(const [AppModule])
// abstract class AppInjector {
//
//   MyApp get app;

//
//   AuthScreen get authScreen;

//
//   HomeScreen get homeScreen;

//
//   SplashScreen get splashScreen;

//   static Future<AppInjector> create() {
//     return g.AppInjector$Injector.create(AppModule());
//   }
// }
final getIt = GetIt.instance;

void diInit() {
  // getIt.registerSingleton<>(instance)
  //dio client
  getIt.registerLazySingleton<Dio>(() {
    var dio = Dio();
    dio.interceptors.add(AppInterceptors());
    dio.interceptors.add(LoggingInterceptors());
    return dio;
  });
  //shared pref
  getIt.registerLazySingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
//cache manager
  getIt.registerLazySingleton<CacheManager>(
    () => CacheManager(),
  );
  //provider api
  getIt.registerLazySingleton<UserApiProvider>(
      () => UserApiProvider(getIt.get<Dio>()));

  //repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt.get<UserApiProvider>(),
      getIt.get<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<FinalRepository>(
    () => FinalRepositoryImpl(
      getIt.get<UserApiProvider>(),
    ),
  );
  getIt.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImpl(
      getIt.get<UserApiProvider>(),
    ),
  );
  getIt.registerLazySingleton<UserCourseRepository>(
    () => UserCourseRepositoryImpl(
      getIt.get<UserApiProvider>(),
      getIt.get<CacheManager>(),
    ),
  );
  getIt.registerLazySingleton<InstructorsRepository>(
    () => InstructorsRepositoryImpl(
      getIt.get<UserApiProvider>(),
    ),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      getIt.get<UserApiProvider>(),
      getIt.get(),
    ),
  );
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      getIt.get<UserApiProvider>(),
    ),
  );
  getIt.registerLazySingleton<QuestionsRepository>(
    () => QuestionsRepositoryImpl(
      getIt.get<UserApiProvider>(),
    ),
  );
  getIt.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(
      getIt.get<UserApiProvider>(),
      getIt.get<CacheManager>(),
    ),
  );
  getIt.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(
      getIt.get<UserApiProvider>(),
    ),
  );
  getIt.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(
      getIt.get<UserApiProvider>(),
    ),
  );
  //bloc
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      getIt.get<AuthRepository>(),
    ),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getIt.get<HomeRepository>(),
      getIt.get<CoursesRepository>(),
      getIt.get<InstructorsRepository>(),
    ),
  );
  getIt.registerFactory<HomeScreen>(() => HomeScreen());

  getIt.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(
      getIt.get<CoursesRepository>(),
    ),
  );
  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(
      getIt.get<AuthRepository>(),
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerLazySingleton<SplashScreen>(
    () => SplashScreen(
      getIt.get(),
    ),
  );

  getIt.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerFactory<DetailProfileBloc>(
    () => DetailProfileBloc(
      getIt.get(),
      getIt.get(),
    ),
  );

  getIt.registerFactory<EditProfileBloc>(
    () => EditProfileBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory<SearchScreenBloc>(
    () => SearchScreenBloc(
      getIt.get(),
    ),
  );

  getIt.registerFactory<SearchDetailBloc>(
    () => SearchDetailBloc(
      getIt.get(),
    ),
  );

  getIt.registerFactory<CourseBloc>(() => CourseBloc(
        getIt.get(),
        getIt.get(),
        getIt.get(),
      ));

  getIt.registerFactory<HomeSimpleBloc>(
    () => HomeSimpleBloc(
      getIt.get(),
    ),
  );

  getIt.registerFactory<CategoryDetailBloc>(
    () => CategoryDetailBloc(
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerFactory<AssignmentBloc>(
    () => AssignmentBloc(
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerFactory<ProfileAssignmentBloc>(() => ProfileAssignmentBloc());
  getIt.registerFactory<ReviewWriteBloc>(
    () => ReviewWriteBloc(
      getIt.get(),
      getIt.get(),
    ),
  );

  getIt.registerFactory<UserCoursesBloc>(() => UserCoursesBloc(
        getIt.get(),
        getIt.get(),
      ));
  getIt.registerFactory<UserCourseBloc>(() => UserCourseBloc(
        getIt.get(),
        getIt.get(),
        getIt.get(),
      ));
  getIt.registerFactory<UserCourseLockedBloc>(() => UserCourseLockedBloc(
        getIt.get(),
      ));
  getIt.registerFactory<TextLessonBloc>(() => TextLessonBloc(
        getIt.get(),
        getIt.get(),
      ));
  getIt.registerFactory<LessonVideoBloc>(() => LessonVideoBloc(
        getIt.get(),
      ));
  getIt.registerFactory<LessonStreamBloc>(() => LessonStreamBloc(
        getIt.get(),
        getIt.get(),
      ));
  getIt.registerFactory<VideoBloc>(() => VideoBloc());
  getIt.registerFactory<QuizLessonBloc>(() => QuizLessonBloc(
        getIt.get(),
        getIt.get(),
      ));
  getIt.registerFactory<QuestionsBloc>(() => QuestionsBloc(
        getIt.get(),
      ));
  getIt.registerFactory<QuestionAskBloc>(() => QuestionAskBloc(
        getIt.get(),
      ));
  getIt.registerFactory<QuestionDetailsBloc>(() => QuestionDetailsBloc(
        getIt.get(),
      ));
  getIt.registerFactory<QuizScreenBloc>(() => QuizScreenBloc(
        getIt.get(),
      ));
  getIt.registerFactory<FinalBloc>(() => FinalBloc(
        getIt.get(),
        getIt.get(),
      ));
  getIt.registerFactory<PlansBloc>(() => PlansBloc(
        getIt.get(),
      ));
  getIt.registerFactory<OrdersBloc>(() => OrdersBloc(
        getIt.get(),
      ));
  getIt.registerFactory<RestorePasswordBloc>(() => RestorePasswordBloc(
        getIt.get(),
      ));
//screen
  getIt.registerFactory<AuthScreen>(
    () => AuthScreen(
      getIt.get<AuthBloc>(),
    ),
  );
}
// @InjectableInit(
//   initializerName: r'$initGetIt', // default
//   preferRelativeImports: true, // default
//   asExtension: false, // default
// )
// void configureDependencies() => $initGetIt(getIt);
