import 'package:masterstudy_app/data/models/InstructorsResponse.dart';
import 'package:masterstudy_app/data/network/api_provider.dart';
import 'package:masterstudy_app/data/utils.dart';

enum InstructorsSort { rating }

abstract class InstructorsRepository {
  Future<List<InstructorBean?>> getInstructors(InstructorsSort sort,
      {int page, int perPage});
}

class InstructorsRepositoryImpl extends InstructorsRepository {
  final UserApiProvider apiProvider;

  InstructorsRepositoryImpl(this.apiProvider);

  @override
  Future<List<InstructorBean?>> getInstructors(InstructorsSort sort,
      {int? page, int? perPage}) async {
    Map<String, dynamic> query = Map();

    switch (sort) {
      case InstructorsSort.rating:
        query.addParam("sort", "rating");
        break;
    }
    final result = await apiProvider.getInstructors(query);
    return (result.data ?? []);
  }
}
