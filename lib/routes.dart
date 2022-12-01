import 'package:flutter/material.dart';
import 'package:masterstudy_app/di/app_injector.dart';
import 'package:masterstudy_app/ui/screen/chat/chat_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/screen/assignment/assignment_screen.dart';
import 'ui/screen/auth/auth_screen.dart';
import 'ui/screen/category_detail/category_detail_screen.dart';
import 'ui/screen/course/course_screen.dart';
import 'ui/screen/detail_profile/detail_profile_screen.dart';
import 'ui/screen/final/final_screen.dart';
import 'ui/screen/lesson_stream/lesson_stream_screen.dart';
import 'ui/screen/lesson_video/lesson_video_screen.dart';
import 'ui/screen/main/main_screen.dart';
import 'ui/screen/orders/orders.dart';
import 'ui/screen/plans/plans_screen.dart';
import 'ui/screen/profile_assignment/profile_assignment_screen.dart';
import 'ui/screen/profile_edit/profile_edit_screen.dart';
import 'ui/screen/question_ask/question_ask_screen.dart';
import 'ui/screen/question_details/question_details_screen.dart';
import 'ui/screen/questions/questions_screen.dart';
import 'ui/screen/quiz_lesson/quiz_lesson_screen.dart';
import 'ui/screen/quiz_screen/quiz_screen.dart';
import 'ui/screen/restore_password/restore_password_screen.dart';
import 'ui/screen/review_write/review_write_screen.dart';
import 'ui/screen/search_detail/search_detail_screen.dart';
import 'ui/screen/splash/splash_screen.dart';
import 'ui/screen/text_lesson/text_lesson_screen.dart';
import 'ui/screen/user_course/user_course.dart';
import 'ui/screen/user_course_locked/user_course_locked_screen.dart';
import 'ui/screen/video_screen/video_screen.dart';
import 'ui/screen/web_checkout/web_checkout_screen.dart';

class Routes {
  Route<dynamic>? call(RouteSettings settings) {
    switch (settings.name) {
      case ChatScreen.routeName:
        return MaterialPageRoute(
          builder: (context) =>
              ChatScreen(courseId: settings.arguments as String),
        );
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => FutureBuilder<void>(
              future: getIt.isReady<SharedPreferences>(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SplashScreen(
                    getIt.get(),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        );
      case AuthScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => AuthScreen(getIt.get()),
          settings: settings,
        );
      case MainScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => MainScreen(),
          settings: settings,
        );
      case CourseScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => CourseScreen(getIt.get()),
            settings: settings);
      case SearchDetailScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => SearchDetailScreen(getIt.get()),
            settings: settings);
      case DetailProfileScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => DetailProfileScreen(getIt.get()),
            settings: settings);
      case ProfileEditScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ProfileEditScreen(getIt.get()),
            settings: settings);
      case CategoryDetailScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(getIt.get()),
            settings: settings);
      case ProfileAssignmentScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ProfileAssignmentScreen(getIt.get()),
            settings: settings);
      case AssignmentScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => AssignmentScreen(getIt.get()),
            settings: settings);
      case ReviewWriteScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => ReviewWriteScreen(getIt.get()),
            settings: settings);
      case UserCourseScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => UserCourseScreen(
                  getIt.get(),
                ),
            settings: settings);
      case TextLessonScreen.routeName:
        return PageTransition(
            child: TextLessonScreen(getIt.get()),
            type: PageTransitionType.leftToRight,
            settings: settings);
      case LessonVideoScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => LessonVideoScreen(getIt.get()),
            settings: settings);
      case LessonStreamScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => LessonStreamScreen(getIt.get()),
            settings: settings);
      case VideoScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => VideoScreen(getIt.get()),
          settings: settings,
        );
      case QuizLessonScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => QuizLessonScreen(getIt.get()),
            settings: settings);
      case QuestionsScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => QuestionsScreen(getIt.get()),
            settings: settings);
      case QuestionAskScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => QuestionAskScreen(getIt.get()),
            settings: settings);
      case QuestionDetailsScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => QuestionDetailsScreen(
                  getIt.get(),
                ),
            settings: settings);
      case FinalScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => FinalScreen(getIt.get()), settings: settings);
      case QuizScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => QuizScreen(getIt.get()), settings: settings);
      case PlansScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => PlansScreen(getIt.get()), settings: settings);
      case WebCheckoutScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => WebCheckoutScreen(), settings: settings);
      case OrdersScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => OrdersScreen(getIt.get()),
            settings: settings);
      case UserCourseLockedScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => UserCourseLockedScreen(getIt.get()),
            settings: settings);
      case RestorePasswordScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => RestorePasswordScreen(getIt.get()),
            settings: settings);
      default:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(
            getIt.get(),
          ),
        );
    }
  }
}
