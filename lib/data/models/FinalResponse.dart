import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'FinalResponse.g.dart';

@JsonSerializable()
class FinalResponse {
  CourseBean? course;
  CurriculumBean? curriculum;
  bool? course_completed;
  String? title;
  String? url;
  String? certificate_url;

  FinalResponse({
    this.course,
    this.curriculum,
    this.course_completed,
    this.title,
    this.url,
    this.certificate_url,
  });

  factory FinalResponse.fromMap(Map<String, dynamic> json) =>
      _$FinalResponseFromJson(json);

  Map<String, dynamic> toMap() => _$FinalResponseToJson(this);

  FinalResponse copyWith({
    CourseBean? course,
    CurriculumBean? curriculum,
    bool? course_completed,
    String? title,
    String? url,
    String? certificate_url,
  }) {
    return FinalResponse(
      course: course ?? this.course,
      curriculum: curriculum ?? this.curriculum,
      course_completed: course_completed ?? this.course_completed,
      title: title ?? this.title,
      url: url ?? this.url,
      certificate_url: certificate_url ?? this.certificate_url,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'course': course?.toMap(),
  //     'curriculum': curriculum?.toMap(),
  //     'course_completed': course_completed,
  //     'title': title,
  //     'url': url,
  //     'certificate_url': certificate_url,
  //   };
  // }

  // factory FinalResponse.fromMap(Map<String, dynamic> map) {
  //   return FinalResponse(
  //     course: CourseBean.fromMap(map['course']),
  //     curriculum: CurriculumBean.fromMap(map['curriculum']),
  //     course_completed: map['course_completed'] ?? false,
  //     title: map['title'] ?? '',
  //     url: map['url'] ?? '',
  //     certificate_url: map['certificate_url'] ?? '',
  //   );
  // }

  String toJson() => json.encode(toMap());

  factory FinalResponse.fromJson(String source) =>
      FinalResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FinalResponse(course: $course, curriculum: $curriculum, course_completed: $course_completed, title: $title, url: $url, certificate_url: $certificate_url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FinalResponse &&
        other.course == course &&
        other.curriculum == curriculum &&
        other.course_completed == course_completed &&
        other.title == title &&
        other.url == url &&
        other.certificate_url == certificate_url;
  }

  @override
  int get hashCode {
    return course.hashCode ^
        curriculum.hashCode ^
        course_completed.hashCode ^
        title.hashCode ^
        url.hashCode ^
        certificate_url.hashCode;
  }
}

@JsonSerializable()
class CourseBean {
  num user_course_id;
  num user_id;
  num course_id;
  num current_lesson_id;
  num progress_percent;
  String status;
  num subscription_id;
  String start_time;
  String lng_code;
  num enterprise_id;
  num bundle_id;

  CourseBean({
    required this.user_course_id,
    required this.user_id,
    required this.course_id,
    required this.current_lesson_id,
    required this.progress_percent,
    required this.status,
    required this.subscription_id,
    required this.start_time,
    required this.lng_code,
    required this.enterprise_id,
    required this.bundle_id,
  });

  factory CourseBean.fromJson(Map<String, dynamic> json) =>
      _$CourseBeanFromJson(json);

  Map<String, dynamic> toMaps() => _$CourseBeanToJson(this);

  CourseBean copyWith({
    num? user_course_id,
    num? user_id,
    num? course_id,
    num? current_lesson_id,
    num? progress_percent,
    String? status,
    num? subscription_id,
    String? start_time,
    String? lng_code,
    num? enterprise_id,
    num? bundle_id,
  }) {
    return CourseBean(
      user_course_id: user_course_id ?? this.user_course_id,
      user_id: user_id ?? this.user_id,
      course_id: course_id ?? this.course_id,
      current_lesson_id: current_lesson_id ?? this.current_lesson_id,
      progress_percent: progress_percent ?? this.progress_percent,
      status: status ?? this.status,
      subscription_id: subscription_id ?? this.subscription_id,
      start_time: start_time ?? this.start_time,
      lng_code: lng_code ?? this.lng_code,
      enterprise_id: enterprise_id ?? this.enterprise_id,
      bundle_id: bundle_id ?? this.bundle_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_course_id': user_course_id,
      'user_id': user_id,
      'course_id': course_id,
      'current_lesson_id': current_lesson_id,
      'progress_percent': progress_percent,
      'status': status,
      'subscription_id': subscription_id,
      'start_time': start_time,
      'lng_code': lng_code,
      'enterprise_id': enterprise_id,
      'bundle_id': bundle_id,
    };
  }

  factory CourseBean.fromMap(Map<String, dynamic> map) {
    return CourseBean(
      user_course_id: map['user_course_id'] ?? 0,
      user_id: map['user_id'] ?? 0,
      course_id: map['course_id'] ?? 0,
      current_lesson_id: map['current_lesson_id'] ?? 0,
      progress_percent: map['progress_percent'] ?? 0,
      status: map['status'] ?? '',
      subscription_id: map['subscription_id'] ?? 0,
      start_time: map['start_time'] ?? '',
      lng_code: map['lng_code'] ?? '',
      enterprise_id: map['enterprise_id'] ?? 0,
      bundle_id: map['bundle_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  // factory CourseBean.fromJson(String source) =>
  //     CourseBean.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CourseBean(user_course_id: $user_course_id, user_id: $user_id, course_id: $course_id, current_lesson_id: $current_lesson_id, progress_percent: $progress_percent, status: $status, subscription_id: $subscription_id, start_time: $start_time, lng_code: $lng_code, enterprise_id: $enterprise_id, bundle_id: $bundle_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseBean &&
        other.user_course_id == user_course_id &&
        other.user_id == user_id &&
        other.course_id == course_id &&
        other.current_lesson_id == current_lesson_id &&
        other.progress_percent == progress_percent &&
        other.status == status &&
        other.subscription_id == subscription_id &&
        other.start_time == start_time &&
        other.lng_code == lng_code &&
        other.enterprise_id == enterprise_id &&
        other.bundle_id == bundle_id;
  }

  @override
  int get hashCode {
    return user_course_id.hashCode ^
        user_id.hashCode ^
        course_id.hashCode ^
        current_lesson_id.hashCode ^
        progress_percent.hashCode ^
        status.hashCode ^
        subscription_id.hashCode ^
        start_time.hashCode ^
        lng_code.hashCode ^
        enterprise_id.hashCode ^
        bundle_id.hashCode;
  }
}

@JsonSerializable()
class CurriculumBean {
  TypeBean? multimedia;
  TypeBean? lesson;
  TypeBean? quiz;
  TypeBean? assignment;

  CurriculumBean(
      {required this.multimedia,
      required this.lesson,
      required this.assignment,
      required this.quiz});

  factory CurriculumBean.fromJson(Map<String, dynamic> json) =>
      _$CurriculumBeanFromJson(json);

  Map<String, dynamic> toMap() => _$CurriculumBeanToJson(this);
}

@JsonSerializable()
class TypeBean {
  num total;
  num completed;

  TypeBean({required this.total, required this.completed});

  factory TypeBean.fromJson(Map<String, dynamic> json) =>
      _$TypeBeanFromJson(json);

  Map<String, dynamic> toJson() => _$TypeBeanToJson(this);
}
