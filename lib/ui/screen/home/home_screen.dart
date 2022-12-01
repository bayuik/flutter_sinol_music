import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterstudy_app/data/models/purchase/post.dart';
import 'package:masterstudy_app/data/network/api_provider.dart';
import 'package:intl/intl.dart';
import 'package:masterstudy_app/di/app_injector.dart';

import 'package:masterstudy_app/ui/bloc/home/bloc.dart';
import 'package:masterstudy_app/ui/widgets/loading_error_widget.dart';
import 'package:masterstudy_app/ui/widgets/my_chrome_safari_browser.dart';

import '../../../theme/theme.dart';
import 'items/categories_item.dart';
import 'items/new_courses_item.dart';
import 'items/top_instructors.dart';
import 'items/trending_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen() : super();

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HomeBloc>(context)..add(FetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ));
  }

  _buildBody(context, state) {
    if (state is LoadedHomeState) {
      return ListView(
        children: [
          buildArticleSection(context),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.layout.length,
              itemBuilder: (context, index) {
                var item = state.layout[index];
                switch (item.id) {
                  case 3:
                    return TrendingWidget(
                        true, item.name ?? "", state.coursesTranding);
                  case 4:
                    return TopInstructorsWidget(
                        item.name ?? "", state.instructors);
                  case 1:
                    return CategoriesWidget(
                        item.name ?? "", state.categoryList);
                  case 2:
                    return NewCoursesWidget(item.name ?? "", state.coursesNew);
                  case 5:
                    return TrendingWidget(
                        false, item.name ?? "", state.coursesFree);
                  default:
                    return NewCoursesWidget(item.name ?? "", state.coursesNew);
                }
              }),
        ],
      );
    }
    if (state is InitialHomeState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ErrorHomeState) {
      return LoadingErrorWidget(() {
        _bloc.add(FetchEvent());
      });
    }
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 144,
            child: FutureBuilder<List<Post>>(
              future: getIt.get<UserApiProvider>().getArticle(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final posts = snapshot.data ?? [];
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final image = posts[index].getLargeImage();
                        return InkWell(
                          onTap: () async {
                            await launchBrowser(posts[index].link);
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
                                        ),
                                ),
                                Text(
                                    posts[index]
                                        .title
                                        .json["rendered"]
                                        .toString(),
                                    textScaleFactor: 1.0,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline6
                                        ?.copyWith(
                                            color: dark,
                                            fontStyle: FontStyle.normal)),

                                //string formatter format datetime to DD, dd mm yy hh:mm

                                Text(DateFormat('EEEE,dd MMM yyyy HH:mm')
                                    .format(posts[index].modifiedGmt)),
                              ]),
                            ),
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("unkown error"),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
