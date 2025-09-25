 import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/feed_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/use_case/get_home_feed.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/category_provider.dart';

class HomeFeedProvider with ChangeNotifier {
  final GetHomeFeedsUseCase getHomeFeedsUseCase;

  HomeFeedProvider(this.getHomeFeedsUseCase);

  List<FeedEntity> _feeds = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FeedEntity> get feeds => _feeds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomeFeeds() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _feeds = await getHomeFeedsUseCase.call();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load feeds: ${e.toString()}';
      _feeds = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
