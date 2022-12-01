import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:masterstudy_app/data/repository/localization_repository.dart';
import 'package:masterstudy_app/firebase_options.dart';
import 'package:masterstudy_app/theme/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/push/push_manager.dart';
import 'di/app_injector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'my_app.dart';

typedef Provider<T> = T Function();

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

late LocalizationRepository localizations;
late Color mainColor, mainColorA, secondColor;

StreamController<Map<String, dynamic>> pushStreamController =
    StreamController<Map<String, dynamic>>();
Stream pushStream = pushStreamController.stream.asBroadcastStream();

bool dripContentEnabled = false;
bool demoEnabled = false;
bool appView = false;

late AndroidDeviceInfo androidInfo;

var iosInfo;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  // Or do other work.
  return null;
}

late Directory appDocDir;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.grey.withOpacity(0.4), //top bar color
    statusBarIconBrightness: Brightness.light, //top bar icons
  ));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // configureDependencies();
  // FirebaseCrashlytics.instance.enableInDevMode = true;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // WidgetsFlutterBinding.ensureInitialized();
  localizations = LocalizationRepositoryImpl(await getDefaultLocalization());
  final SharedPreferences _sharedPreferences =
      await SharedPreferences.getInstance();
  appView = _sharedPreferences.getBool("app_view") ?? false;
  diInit();
  await setColors();
  if (Platform.isAndroid) androidInfo = await DeviceInfoPlugin().androidInfo;
  if (Platform.isIOS) iosInfo = await DeviceInfoPlugin().iosInfo;
  PushNotificationsManager().init();
  appDocDir = await getApplicationDocumentsDirectory();

  // // configureDependencies();
  // runApp(MyWidget());
  runApp(MyApp());
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
        title: Text("sadad"),
      )),
    );
  }
}

Future<bool> setColors() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  try {
    final mcr = sharedPreferences.getInt("main_color_r")!;
    final mcg = sharedPreferences.getInt("main_color_g")!;
    final mcb = sharedPreferences.getInt("main_color_b")!;
    final mca = sharedPreferences.getDouble("main_color_a")!;

    final scr = sharedPreferences.getInt("second_color_r")!;
    final scg = sharedPreferences.getInt("second_color_g")!;
    final scb = sharedPreferences.getInt("second_color_b")!;
    final sca = sharedPreferences.getDouble("second_color_a")!;

    mainColor = Color.fromRGBO(mcr, mcg, mcb, mca);
    mainColorA = Color.fromRGBO(mcr, mcg, mcb, 0.999);
    secondColor = Color.fromRGBO(scr, scg, scb, sca);
  } catch (e) {
    mainColor = blue_blue;
    mainColorA = blue_blue_a;
    secondColor = seaweed;
  }
  return true;
}

Future<String> getDefaultLocalization() async {
  String data =
      await rootBundle.loadString('assets/localization/default_locale.json');
  return data;
}

late String appLogoUrl;

// @Singleton()
// class MyApp extends StatefulWidget {
//   final Provider<AuthScreen> authScreen;
//   final Provider<HomeBloc> homeBloc;
//   final Provider<FavoritesBloc> favoritesBloc;
//   final Provider<SplashScreen> splashScreen;
//   final Provider<ProfileBloc> profileBloc;
//   final Provider<DetailProfileBloc> detailProfileBloc;
//   final Provider<EditProfileBloc> editProfileBloc;
//   final Provider<SearchScreenBloc> searchScreenBloc;
//   final Provider<SearchDetailBloc> searchDetailBloc;
//   final Provider<CourseBloc> courseBloc;
//   final Provider<HomeSimpleBloc> homeSimpleBloc;
//   final Provider<CategoryDetailBloc> categoryDetailBloc;
//   final Provider<AssignmentBloc> assignmentBloc;
//   final Provider<ProfileAssignmentBloc> profileAssignmentBloc;
//   final Provider<ReviewWriteBloc> reviewWriteBloc;
//   final Provider<UserCoursesBloc> userCoursesBloc;
//   final Provider<UserCourseBloc> userCourseBloc;
//   final Provider<UserCourseLockedBloc> userCourseLockedBloc;
//   final Provider<TextLessonBloc> textLessonBloc;
//   final Provider<LessonVideoBloc> lessonVideoBloc;
//   final Provider<LessonStreamBloc> lessonStreamBloc;
//   final Provider<VideoBloc> videoBloc;
//   final Provider<QuizLessonBloc> quizLessonBloc;
//   final Provider<QuestionsBloc> questionsBloc;
//   final Provider<QuestionAskBloc> questionAskBloc;
//   final Provider<QuestionDetailsBloc> questionDetailsBloc;
//   final Provider<QuizScreenBloc> quizScreenBloc;
//   final Provider<FinalBloc> finalBloc;
//   final Provider<PlansBloc> plansBloc;
//   final Provider<OrdersBloc> ordersBloc;
//   final Provider<RestorePasswordBloc> restorePasswordBloc;

//   const MyApp(
//     this.authScreen,
//     this.homeBloc,
//     this.splashScreen,
//     this.favoritesBloc,
//     this.profileBloc,
//     this.editProfileBloc,
//     this.detailProfileBloc,
//     this.searchScreenBloc,
//     this.searchDetailBloc,
//     this.courseBloc,
//     this.homeSimpleBloc,
//     this.categoryDetailBloc,
//     this.profileAssignmentBloc,
//     this.assignmentBloc,
//     this.reviewWriteBloc,
//     this.userCoursesBloc,
//     this.userCourseBloc,
//     this.userCourseLockedBloc,
//     this.textLessonBloc,
//     this.quizLessonBloc,
//     this.lessonVideoBloc,
//     this.lessonStreamBloc,
//     this.videoBloc,
//     this.questionsBloc,
//     this.questionAskBloc,
//     this.questionDetailsBloc,
//     this.quizScreenBloc,
//     this.finalBloc,
//     this.plansBloc,
//     this.ordersBloc,
//     this.restorePasswordBloc,
//   ) : super();

//   _getProvidedMainScreen() {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<HomeBloc>(create: (BuildContext context) => homeBloc()),
//         BlocProvider<HomeSimpleBloc>(
//             create: (BuildContext context) => getIt.get()),
//         BlocProvider<FavoritesBloc>(
//             create: (BuildContext context) => favoritesBloc()),
//         BlocProvider<SearchScreenBloc>(
//             create: (BuildContext context) => searchScreenBloc()),
//         BlocProvider<UserCoursesBloc>(
//             create: (BuildContext context) => userCoursesBloc()),
//       ],
//       child: MainScreen(),
//     );
//   }

//   ThemeData _buildShrineTheme() {
//     final ThemeData base = ThemeData.light();
//     return base.copyWith(
//       accentColor: mainColor,
//       primaryColor: mainColor,
//       buttonTheme: buttonThemeData,
//       buttonBarTheme: base.buttonBarTheme.copyWith(
//         buttonTextTheme: ButtonTextTheme.accent,
//       ),
//       cardTheme: CardTheme(
//         shape: RoundedRectangleBorder(
//           borderRadius: const BorderRadius.all(
//             Radius.circular(10.0),
//           ),
//         ),
//       ),
//       scaffoldBackgroundColor: Colors.white,
//       cardColor: Colors.white,
//       textTheme: getTextTheme(base.primaryTextTheme),
//       primaryTextTheme: getTextTheme(base.primaryTextTheme).apply(
//         bodyColor: mainColor,
//         displayColor: mainColor,
//       ),
//       accentTextTheme: textTheme,
//       textSelectionColor: mainColor.withOpacity(0.4),
//       errorColor: Colors.red[400],
//     );
//   }

//   @override
//   State<StatefulWidget> createState() {
//     return MyAppState();
//   }
// }


// class MyAppState extends State<MyApp> {
//   late StreamSubscription<List<PurchaseDetails>> _subscription;

//   /// Is the API available on the device
//   bool _available = true;

//   /// The In App Purchase plugin
//   ///
//   // InAppPurchaseConnection _iap;
//   // InAppPurchase
//   InAppPurchase _iap = InAppPurchase.instance;

//   /// Products for sale
//   List<ProductDetails> _products = [];

//   /// Past purchases
//   List<PurchaseDetails> _purchases = [];

//   @override
//   void initState() {
//     _initialize();
//     super.initState();
//   }

//   void _buyProduct(ProductDetails prod) {
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
//     _iap.buyNonConsumable(purchaseParam: purchaseParam);
//     _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
//   }

//   void _initialize() async {
//     // Check availability of In App Purchases
//     _available = await _iap.isAvailable();

//     _subscription = _iap.purchaseStream.listen((data) => setState(() {
//           print('NEW PURCHASE');
//           _purchases.addAll(data);
//           // _verifyPurchase(data);
//         }));

//     if (_available) {
//       await _getProducts();
//       await _getPastPurchases();

//       // Verify and deliver a purchase with your own business logic
//       // _verifyPurchase();
//     }
//   }

//   /// Get all products available for sale
//   Future<void> _getProducts() async {
//     Set<String> ids = Set.from(['test_a']);
//     ProductDetailsResponse response = await _iap.queryProductDetails(ids);

//     setState(() {
//       _products = response.productDetails;
//     });
//   }

//   /// Gets past purchases
//   Future<void> _getPastPurchases() async {
// //     QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
// // _iap.restorePurchases();
// //     for (PurchaseDetails purchase in response.pastPurchases) {
// //       if (Platform.isIOS) {
// //         InAppPurchaseConnection.instance.completePurchase(purchase);
// //       }
// //     }

//     // setState(() {
//     //   _purchases = response.pastPurchases;
//     // });
//   }

//   /// Returns purchase of specific product ID
//   PurchaseDetails? _hasPurchased(String productID) {
//     final filter =
//         _purchases.where((element) => element.purchaseID == productID);
//     if (_purchases.isEmpty) {
//       return null;
//     }

//     return filter.first;
//     // return _purchases.firstWhere((purchase) => purchase.productID == productID,
//     //     orElse: () => null);
//   }

//   /// Your own business logic to setup a consumable
//   void _verifyPurchase(String productID) {
//     PurchaseDetails? purchase = _hasPurchased(productID);

//     // TODO serverside verification & record consumable in the database

//     if (purchase != null && purchase.status == PurchaseStatus.purchased) {}
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     pushStream.listen((event) {
//       var message = event as Map<String, dynamic>;
//       var notification = message["notification"];
//       showOverlayNotification((context) {
//         return MessageNotification(
//           notification["title"],
//           notification["body"],
//           onReplay: () {
//             OverlaySupportEntry.of(context)?.dismiss();
//           },
//         );
//       }, duration: Duration(seconds: 5));
//     });
//     return BlocProvider(
//       create: (BuildContext context) => widget.profileBloc(),
//       child: OverlaySupport(
//         child: MaterialApp(
//           title: 'Masterstudy',
//           theme: widget._buildShrineTheme(),
//           initialRoute: SplashScreen.routeName,
//           debugShowCheckedModeBanner: false,
//           // ignore: missing_return
//           navigatorKey: navigatorKey,
//           onGenerateRoute: (routeSettings) {
//             // switch (routeSettings.name) {
//             //   case SplashScreen.routeName:
//             //     // ignore: missing_return
//             //     return MaterialPageRoute(
//             //         builder: (context) => widget.splashScreen());
//             //   case AuthScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => widget.authScreen(),
//             //         settings: routeSettings);
//             //   case MainScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => widget._getProvidedMainScreen(),
//             //         settings: routeSettings);
//             //   case CourseScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => CourseScreen(widget.courseBloc()),
//             //         settings: routeSettings);
//             //   case SearchDetailScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             SearchDetailScreen(widget.searchDetailBloc()),
//             //         settings: routeSettings);
//             //   case DetailProfileScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             DetailProfileScreen(widget.detailProfileBloc()),
//             //         settings: routeSettings);
//             //   case ProfileEditScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             ProfileEditScreen(widget.editProfileBloc()),
//             //         settings: routeSettings);
//             //   case CategoryDetailScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             CategoryDetailScreen(widget.categoryDetailBloc()),
//             //         settings: routeSettings);
//             //   case ProfileAssignmentScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             ProfileAssignmentScreen(widget.profileAssignmentBloc()),
//             //         settings: routeSettings);
//             //   case AssignmentScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             AssignmentScreen(widget.assignmentBloc()),
//             //         settings: routeSettings);
//             //   case ReviewWriteScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             ReviewWriteScreen(widget.reviewWriteBloc()),
//             //         settings: routeSettings);
//             //   case UserCourseScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => UserCourseScreen(
//             //               widget.userCourseBloc(),
//             //             ),
//             //         settings: routeSettings);
//             //   case TextLessonScreen.routeName:
//             //     return PageTransition(
//             //         child: TextLessonScreen(widget.textLessonBloc()),
//             //         type: PageTransitionType.leftToRight,
//             //         settings: routeSettings);
//             //   case LessonVideoScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             LessonVideoScreen(widget.lessonVideoBloc()),
//             //         settings: routeSettings);
//             //   case LessonStreamScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             LessonStreamScreen(widget.lessonStreamBloc()),
//             //         settings: routeSettings);
//             //   case VideoScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => VideoScreen(widget.videoBloc()),
//             //         settings: routeSettings);
//             //   case QuizLessonScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             QuizLessonScreen(widget.quizLessonBloc()),
//             //         settings: routeSettings);
//             //   case QuestionsScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             QuestionsScreen(widget.questionsBloc()),
//             //         settings: routeSettings);
//             //   case QuestionAskScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             QuestionAskScreen(widget.questionAskBloc()),
//             //         settings: routeSettings);
//             //   case QuestionDetailsScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             QuestionDetailsScreen(widget.questionDetailsBloc()),
//             //         settings: routeSettings);
//             //   case FinalScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => FinalScreen(widget.finalBloc()),
//             //         settings: routeSettings);
//             //   case QuizScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => QuizScreen(widget.quizScreenBloc()),
//             //         settings: routeSettings);
//             //   case PlansScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => PlansScreen(widget.plansBloc()),
//             //         settings: routeSettings);
//             //   case WebCheckoutScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => WebCheckoutScreen(),
//             //         settings: routeSettings);
//             //   case OrdersScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) => OrdersScreen(widget.ordersBloc()),
//             //         settings: routeSettings);
//             //   case UserCourseLockedScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             UserCourseLockedScreen(widget.courseBloc()),
//             //         settings: routeSettings);
//             //   case RestorePasswordScreen.routeName:
//             //     return MaterialPageRoute(
//             //         builder: (context) =>
//             //             RestorePasswordScreen(widget.restorePasswordBloc()),
//             //         settings: routeSettings);
//             //   default:
//             //     return MaterialPageRoute(
//             //         builder: (context) => widget.splashScreen());
//             // }
            
//           },
          
//         ),
//       ),
//     );
//   }
// }
