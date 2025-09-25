
import '../../domain/entity/feed_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../services/home_api_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService apiService;

  HomeRepositoryImpl(this.apiService);

  @override
  Future<List<FeedEntity>> getHomeFeeds() async {
    final feeds = await apiService.fetchHomeFeeds();
    return feeds;
  }
}
