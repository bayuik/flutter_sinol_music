import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  static final MyChromeSafariBrowser instance = MyChromeSafariBrowser();
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

Future<void> launchBrowser(String url) async {
  await MyChromeSafariBrowser.instance.open(
    url: Uri.parse("$url"),
    options: ChromeSafariBrowserClassOptions(
      android: AndroidChromeCustomTabsOptions(
          shareState: CustomTabsShareState.SHARE_STATE_OFF),
      ios: IOSSafariOptions(barCollapsingEnabled: true),
    ),
  );
}
