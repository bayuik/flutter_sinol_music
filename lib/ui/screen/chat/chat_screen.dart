import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:masterstudy_app/data/models/account.dart';
import 'package:masterstudy_app/data/models/message.dart';
import 'package:intl/intl.dart';
import 'package:masterstudy_app/data/repository/account_repository.dart';
import 'package:masterstudy_app/data/repository/auth_repository.dart';
import 'package:masterstudy_app/di/app_injector.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required String this.courseId}) : super(key: key);
  static const String routeName = '/chat';
  final courseId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _textController;
  Account? account;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _textController = TextEditingController();
    _scrollController = ScrollController();
    loadToken();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void loadToken() async {
    account = await getIt
        .get<AccountRepository>()
        .getUserAccount()
        .whenComplete(() => setState(() {}));
    print(" token: ${account?.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat forum'),
      ),
      body: account == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: ListMessages(
                  userId: account?.id.toString() ?? "",
                  courseId: widget.courseId.toString(),
                  scrollController: _scrollController,
                )),
                SizedBox(
                  height: 75,
                  width: MediaQuery.of(context).size.width,
                  child: Material(
                    elevation: 10,
                    child: Container(
                      color: Colors.white,
                      height: 75,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _textController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.grey),
                                hintText: "  Tambahkan Pesan...",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              if (_textController.text.isNotEmpty) {
                                FirebaseFirestore.instance
                                    .collection("forum")
                                    .add(Message(
                                            sentAt: Timestamp.now(),
                                            idCourse: widget.courseId,
                                            idUser:
                                                account?.id?.toString() ?? "",
                                            username: account?.login ?? "",
                                            message: _textController.text)
                                        .toJson());
                                _textController.clear();
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                              _textController.clear();
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.bounceIn);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ListMessages extends StatelessWidget {
  const ListMessages({
    Key? key,
    required this.courseId,
    required this.userId,
    required this.scrollController,
  }) : super(key: key);
  final String userId;
  final String courseId;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("forum")
          .where('id_course', isEqualTo: courseId)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Center(child: CircularProgressIndicator());
          default:
            final length = snapshot.data?.docs.length ?? 0;
            if (length < 1) {
              return Center(child: Text("Tidak ada pesan"));
            }
            return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(8),
                itemCount: length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data?.docs[index].data() == null) {
                    return SizedBox();
                  }
                  final data = snapshot.data?.docs[index].data();
                  // final message = Message.fromJson(data);
                  final isSender = data?["id_user"] == userId;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: isSender
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        ChatBubble(
                          alignment: Alignment.topRight,
                          clipper: isSender
                              ? ChatBubbleClipper5(type: BubbleType.sendBubble)
                              : ChatBubbleClipper5(
                                  type: BubbleType.receiverBubble),
                          child: Column(
                            crossAxisAlignment: isSender
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                data?['username'],
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                data?['message'],
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy hh:mm').format(
                                  (snapshot.data?.docs[index].data()['sent_at']
                                          as Timestamp)
                                      .toDate(),
                                ),
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
        }
      },
    );
  }
}
