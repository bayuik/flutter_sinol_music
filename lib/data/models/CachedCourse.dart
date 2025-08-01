import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/user_course.dart';

import 'LessonResponse.dart';
import 'curriculum.dart';
part 'CachedCourse.g.dart';

@JsonSerializable(explicitToJson: true)
class CachedCourse {
  int? id;
  String? hash;
  PostsBean? postsBean;
  CurriculumResponse? curriculumResponse;
  List<LessonResponse?>? lessons = [];

  CachedCourse(
      {this.id,
      this.postsBean,
      this.curriculumResponse,
      this.lessons = const [],
      this.hash});
  factory CachedCourse.fromJson(Map<String, dynamic> json) =>
      _$CachedCourseFromJson(json);

  Map<String, dynamic> toJson() => _$CachedCourseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CachedCourses {
  List<CachedCourse?>? courses;
  CachedCourses({this.courses = const []});
  factory CachedCourses.fromJson(Map<String, dynamic> json) =>
      _$CachedCoursesFromJson(json);
  Map<String, dynamic> toJson() => _$CachedCoursesToJson(this);
}
