import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/theme.dart';
import 'package:masterstudy_app/ui/bloc/course/bloc.dart';
import 'package:masterstudy_app/ui/bloc/user_course_locked/bloc.dart';
import 'package:masterstudy_app/ui/screen/detail_profile/detail_profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogAuthorWidget extends StatelessWidget {
  final dynamic courseState;

  DialogAuthorWidget(this.courseState);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 15.0, left: 20.0, right: 20.0),
                  child: _buildBody(context, this.courseState),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildBody(BuildContext context, dynamic state) {
    if (state is LoadedCourseState || state is LoadedUserCourseLockedState) {
      var authorName = state.courseDetailResponse.author.login;
      if (state.courseDetailResponse.author.meta.first_name != null) {
        authorName = state.courseDetailResponse.author.meta.first_name;
        if (state.courseDetailResponse.author.meta.last_name != null) {
          authorName = authorName +
              " " +
              state.courseDetailResponse.author.meta.last_name;
        }
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        state.courseDetailResponse.author.meta.position ?? "",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: HexColor.fromHex("#AAAAAA")),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                          authorName,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: HexColor.fromHex("#273044")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            RatingBar.builder(
                              initialRating: state
                                  .courseDetailResponse.author.rating.average
                                  .toDouble(),
                              minRating: 0,
                              direction: Axis.horizontal,
                              tapOnlyMode: true,
                              glow: false,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              unratedColor: HexColor.fromHex("#CCCCCC"),
                              itemCount: 5,
                              itemSize: 19,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  "${state.courseDetailResponse.author.rating.average.toDouble()}",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: HexColor.fromHex("#273044"))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                "(${state.courseDetailResponse.author.rating.total_marks})",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: HexColor.fromHex("#AAAAAA")),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        //TODO: ADD FIELD FROM API
                        "",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: HexColor.fromHex("#273044")),
                      )
                    ],
                  )),
              SizedBox(
                width: 50,
                height: 50,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              state.courseDetailResponse.author.avatar_url)),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: MaterialButton(
                      height: 36,
                      color: mainColor,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          DetailProfileScreen.routeName,
                          arguments: DetailProfileScreenArgs.fromId(
                              state.courseDetailResponse.author.id),
                        );
                      },
                      child: Text(
                        localizations.getLocalization("profile_button"),
                        textScaleFactor: 1.0,
                      )),
                ),
                Visibility(
                  visible:
                      state.courseDetailResponse.author.meta.facebook != null &&
                          state.courseDetailResponse.author.meta.facebook != "",
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            state.courseDetailResponse.author.meta.facebook);
                      },
                      child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Image(
                              image: AssetImage('assets/icons/soc_fb.png'))),
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      state.courseDetailResponse.author.meta.twitter != null &&
                          state.courseDetailResponse.author.meta.twitter != "",
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            state.courseDetailResponse.author.meta.twitter);
                      },
                      child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Image(
                              image: AssetImage('assets/icons/soc_twit.png'))),
                    ),
                  ),
                ),
                Visibility(
                  visible: state.courseDetailResponse.author.meta.instagram !=
                          null &&
                      state.courseDetailResponse.author.meta.instagram != "",
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchURL(
                            state.courseDetailResponse.author.meta.instagram);
                      },
                      child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Image(
                              image: AssetImage('assets/icons/soc_insta.png'))),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    await launch(url);
  }
}
