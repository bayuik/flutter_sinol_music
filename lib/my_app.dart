import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:masterstudy_app/routes.dart';
import 'package:overlay_support/overlay_support.dart';
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
import 'data/repository/localization_repository.dart';
import 'di/app_injector.dart';
import 'main.dart';
import 'theme/theme.dart';
import 'ui/screen/splash/splash_screen.dart';
import 'ui/widgets/message_notification.dart';

typedef Provider<T> = T Function();

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

// late LocalizationRepository localizations;
// late Color mainColor, mainColorA, secondColor;

StreamController<Map<String, dynamic>> pushStreamController =
    StreamController<Map<String, dynamic>>();
Stream pushStream = pushStreamController.stream.asBroadcastStream();

bool dripContentEnabled = false;
bool demoEnabled = false;
bool appView = false;

// late AndroidDeviceInfo androidInfo;

// var iosInfo;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<HomeBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<FavoritesBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<ProfileBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<DetailProfileBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<EditProfileBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<SearchScreenBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<SearchDetailBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<CourseBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<HomeSimpleBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<CategoryDetailBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<AssignmentBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<ProfileAssignmentBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<ReviewWriteBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<UserCoursesBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<UserCourseBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<UserCourseLockedBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<TextLessonBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<LessonVideoBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<LessonStreamBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<VideoBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<QuizLessonBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<QuestionsBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<QuestionAskBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<QuestionDetailsBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<QuizScreenBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<FinalBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<PlansBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<OrdersBloc>(
        create: (context) => getIt.get(),
      ),
      BlocProvider<RestorePasswordBloc>(
        create: (context) => getIt.get(),
      ),
    ], child: ContentWidget());
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({Key? key}) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  /// Is the API available on the device
  bool _available = true;

  /// The In App Purchase plugin
  ///
  // InAppPurchaseConnection _iap;
  // InAppPurchase
  InAppPurchase _iap = InAppPurchase.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  void _initialize() async {
    // Check availability of In App Purchases
    _available = await _iap.isAvailable();
    pushStream.listen((event) {
      var message = event as Map<String, dynamic>;
      var notification = message["notification"];
      showOverlayNotification((context) {
        return MessageNotification(
          notification["title"],
          notification["body"],
          onReplay: () {
            OverlaySupportEntry.of(context)?.dismiss();
          },
        );
      }, duration: Duration(seconds: 5));
    });
    _subscription = _iap.purchaseStream.listen((data) => setState(() {
          print('NEW PURCHASE');
          _purchases.addAll(data);
          // _verifyPurchase(data);
        }));

    if (_available) {
      await _getProducts();
      await _getPastPurchases();

      // Verify and deliver a purchase with your own business logic
      // _verifyPurchase();
    }
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from(['test_a']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
//     QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
// _iap.restorePurchases();
//     for (PurchaseDetails purchase in response.pastPurchases) {
//       if (Platform.isIOS) {
//         InAppPurchaseConnection.instance.completePurchase(purchase);
//       }
//     }

    // setState(() {
    //   _purchases = response.pastPurchases;
    // });
  }

  /// Returns purchase of specific product ID
  PurchaseDetails? _hasPurchased(String productID) {
    final filter =
        _purchases.where((element) => element.purchaseID == productID);
    if (_purchases.isEmpty) {
      return null;
    }

    return filter.first;
    // return _purchases.firstWhere((purchase) => purchase.productID == productID,
    //     orElse: () => null);
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase(String productID) {
    PurchaseDetails? purchase = _hasPurchased(productID);

    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {}
  }

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // @override
  // void dispose() {
  //   _subscription.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        navigatorKey: navigatorKey,
        // theme: _buildShrineTheme(),

        theme: ThemeData(
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            labelStyle: TextStyle(color: Colors.black), // color for text
            indicator: UnderlineTabIndicator(
              // color for indicator (underline)
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        ),
        title: 'Sinol',
        // debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes(),
        initialRoute: SplashScreen.routeName,
      ),
    );
  }

  ThemeData _buildShrineTheme() {
    try {
      final ThemeData base = ThemeData.light().copyWith(
        accentColor: mainColor,
        primaryColor: mainColor,
        buttonTheme: buttonThemeData,
        buttonBarTheme: ThemeData.light().buttonBarTheme.copyWith(
              buttonTextTheme: ButtonTextTheme.accent,
            ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: getTextTheme(ThemeData.light().primaryTextTheme),
        primaryTextTheme:
            getTextTheme(ThemeData.light().primaryTextTheme).apply(
          bodyColor: mainColor,
          displayColor: mainColor,
        ),
        accentTextTheme: textTheme,
        textSelectionColor: mainColor.withOpacity(0.4),
        errorColor: Colors.red[400],
      );

      return base;
    } catch (e) {
      print(e);
      return ThemeData();
    }
  }
}
