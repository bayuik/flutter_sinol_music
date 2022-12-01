import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/theme.dart';
import 'package:masterstudy_app/ui/screen/search_detail/search_detail_screen.dart';
import 'package:masterstudy_app/ui/bloc/home_simple/bloc.dart';

import 'package:masterstudy_app/ui/widgets/course_grid_item.dart';
import 'package:intl/intl.dart';
import '../../../data/models/purchase/post.dart';
import '../../../data/network/api_provider.dart';
import '../../../di/app_injector.dart';
import '../../../theme/theme.dart';
import '../../widgets/course_grid_item.dart';
import '../../widgets/my_chrome_safari_browser.dart';

class HomeSimpleScreen extends StatefulWidget {
  const HomeSimpleScreen() : super();

  @override
  State<StatefulWidget> createState() {
    return _HomeSimpleScreenState();
  }
}

class _HomeSimpleScreenState extends State<HomeSimpleScreen> {
  late HomeSimpleBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HomeSimpleBloc>(context)
      ..add(FetchHomeSimpleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor.fromHex("F3F5F9"),
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(26),
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        SearchDetailScreen.routeName,
                        arguments: SearchDetailScreenArgs(""));
                  },
                  child: new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Container(
                        padding: EdgeInsets.all(8.0),
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Expanded(
                                    child: new Text(
                                  localizations
                                      .getLocalization("search_bar_title"),
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5)),
                                )),
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ),
        body: BlocBuilder<HomeSimpleBloc, HomeSimpleState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ));
  }

  Widget buildArticleSection(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Article",
                textScaleFactor: 1.0,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline3
                    ?.copyWith(color: dark, fontStyle: FontStyle.normal),
              ),
            ],
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   height: 144,
          //   child: FutureBuilder<List<Post>>(
          //     future: getIt.get<UserApiProvider>().getArticle(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         final posts = snapshot.data ?? [];
          //         return ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             itemCount: posts.length,
          //             itemBuilder: (context, index) {
          //               final image = posts[0].getLargeImage();
          //               return InkWell(
          //                 onTap: () async {
          //                   await launchBrowser(posts[0].link);
          //                 },
          //                 child: Card(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(16.0),
          //                     child: Column(children: [
          //                       Expanded(
          //                         child: image == null
          //                             ? Container(
          //                                 color: Theme.of(context).primaryColor,
          //                               )
          //                             : Image.network(
          //                                 image,
          //                                 fit: BoxFit.cover,
          //                               ),
          //                       ),
          //                       Text(
          //                           posts[0]
          //                               .title
          //                               .json["rendered"]
          //                               .toString(),
          //                           textScaleFactor: 1.0,
          //                           style: Theme.of(context)
          //                               .primaryTextTheme
          //                               .headline6
          //                               ?.copyWith(
          //                                   color: dark,
          //                                   fontStyle: FontStyle.normal)),
          //
          //                       //string formatter format datetime to DD, dd mm yy hh:mm
          //
          //                       Text(DateFormat('EEEE,dd MMM yyyy HH:mm')
          //                           .format(posts[index].modifiedGmt)),
          //                     ]),
          //                   ),
          //                 ),
          //               );
          //             });
          //       } else if (snapshot.hasError) {
          //         return Center(
          //           child: Text("unkown error"),
          //         );
          //       } else {
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //     },
          //   ),
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 144,
            child: FutureBuilder<List<Post>>(
              future: getIt.get<UserApiProvider>().getArticle(),
              builder: (context, snapshot) {
                final posts = snapshot.data;
                // lenght of post
                final length = posts?.length ?? 0;
                // title of post
                final title = posts?.map((e) => e.title).toList();
                // final image = posts?.map((e) => e.getLargeImage()).toList();
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: posts?.length,
                  itemBuilder: (context, index) {
                    final image = null;
                    return InkWell(
                      onTap: () async {
                        await launchBrowser(posts![index].link);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Expanded(
                                child: image == null
                                    ? Container(
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : Image.network(
                                        image,
                                        fit: BoxFit.cover,
                                      )),
                            Text(title![index].json["rendered"].toString(),
                                textScaleFactor: 1.0,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6
                                    ?.copyWith(
                                        color: dark,
                                        fontStyle: FontStyle.normal)),
                            Text(DateFormat('EEEE,dd MMM yyyy HH:mm')
                                .format(posts![index].modifiedGmt)),
                          ]),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _buildBody(context, state) {
    if (state is LoadedHomeSimpleState) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildArticleSection(context),
            Padding(
                padding: const EdgeInsets.only(
                    top: 25.0, left: 30.0, right: 30.0, bottom: 10.0),
                child: Text(localizations.getLocalization("new_courses_title"),
                    textScaleFactor: 1.0,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline3
                        ?.copyWith(color: dark, fontStyle: FontStyle.normal))),
            _buildCourses(state)
          ],
        ),
      );
    }
    if (state is InitialHomeSimpleState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  _buildCourses(LoadedHomeSimpleState state) {
    double ratio = (MediaQuery.of(context).size.width > 375) ? 0.8 : 0.75;

    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
      child: Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: ratio,
            crossAxisCount: 2,
          ),
          itemCount: state.coursesNew.length,
          itemBuilder: (context, index) {
            var item = state.coursesNew[index];
            debugPrint("data:" +
                state.coursesNew.map((e) => e.toJson().toString()).toString());
            return CourseGridItem(item);
          },
        ),
      ),
    );
  }
}
