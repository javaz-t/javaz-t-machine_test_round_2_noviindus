
import 'package:machine_test_round_2_noviindus/domain/entity/feed_entity.dart';

abstract class HomeRepository {
  Future<List<FeedEntity>> getHomeFeeds();
}
