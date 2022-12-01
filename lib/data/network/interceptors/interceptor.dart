import 'dart:async';

import 'package:dio/dio.dart';
import 'package:masterstudy_app/data/cache/cache_manager.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:masterstudy_app/ui/screen/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers.containsKey("requirestoken")) {
      //remove the auxiliary header
      options.headers.remove("requirestoken");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var header = prefs.get("apiToken");
      options.headers.addAll({"token": "$header"});

      super.onRequest(options, handler);
      return;
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response != null &&
        err.response?.statusCode != null &&
        err.response?.statusCode == 401) {
      (await CacheManager()).cleanCache();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("apiToken", "");
      navigatorKey.currentState?.pushNamed(SplashScreen.routeName);
    }

    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}

class AppInterceptorss extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }
}
