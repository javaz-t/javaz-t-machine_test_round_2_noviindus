

import 'package:machine_test_round_2_noviindus/domain/entity/feed_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/repository/home_repository.dart';

class GetHomeFeedsUseCase {
  final HomeRepository repository;

  GetHomeFeedsUseCase(this.repository);

  Future<List<FeedEntity>> call() async {
    return await repository.getHomeFeeds();
  }
}
