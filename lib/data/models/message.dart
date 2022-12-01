// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.sentAt,
    required this.idCourse,
    required this.idUser,
    required this.username,
    required this.message,
  });

  final Timestamp sentAt;
  final String idCourse;
  final String idUser;
  final String username;
  final String message;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sentAt: json["sent_at"],
        idCourse: json["id_course"] ?? "",
        idUser: json["id_user"] ?? "",
        username: json["username"] ?? "",
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "sent_at": sentAt,
        "id_course": idCourse,
        "id_user": idUser,
        "username": username,
        "message": message,
      };
}
