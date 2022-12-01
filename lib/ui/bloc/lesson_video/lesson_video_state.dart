import 'package:masterstudy_app/data/models/LessonResponse.dart';
import 'package:meta/meta.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

@immutable
abstract class LessonVideoState {}

class InitialLessonVideoState extends LessonVideoState {}

class LoadedLessonVideoState extends LessonVideoState {
  final LessonResponse lessonResponse;
  YoutubePlayerController? controller;
  void disposeController() {
    controller?.dispose();
    controller == null;
  }

  void setController(YoutubePlayerController controller) {
    this.controller = controller;
  }

  LoadedLessonVideoState(this.lessonResponse, {this.controller});
}
