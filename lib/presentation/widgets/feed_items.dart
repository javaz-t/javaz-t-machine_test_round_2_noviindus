import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/feed_entity.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/home_feed_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/video_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import 'custom_text.dart';

class FeedItemWidget extends StatelessWidget {
  final FeedEntity feed;
  final int index;

  const FeedItemWidget({super.key, required this.feed, required this.index});

  @override
  Widget build(BuildContext context) {
    print(feed.toString());

    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        // Check if this feed item is the one currently playing or loading
        final isPlaying =
            videoProvider.currentIndex == index &&
            videoProvider.currentController != null;

        return Column(
          children: [
            21.vs(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: CircleAvatar(backgroundImage: NetworkImage(feed.imageUrl),),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min
                  ,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: CustomText(
                        text: feed.user.name,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    7.vs(),
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: CustomText(
                        text: "5 days ago",
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

              ],
            ),12.vs(),
            VideoPlayerWidget(
              index: index,
              imageUrl: feed.imageUrl,
              videoUrl: feed.videoUrl,
            ),
            10.vs(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: CustomText(fontSize: 12,fontWeight: FontWeight.w300,text: 'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse...'),
            ),

          ],
        );
      },
    );
  }

  Widget _buildFeedsList() {
    return Consumer<HomeFeedProvider>(
      builder: (context, feedProvider, child) {
        if (feedProvider.isLoading && feedProvider.feeds.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentRed),
            ),
          );
        }

        if (feedProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  feedProvider.errorMessage!,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: AppColors.error,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    feedProvider.fetchHomeFeeds();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (feedProvider.feeds.isEmpty) {
          return const Center(
            child: Text(
              'No feeds available',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: AppColors.secondaryText,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: feedProvider.feeds.length,
          itemBuilder: (context, index) {
            return FeedItemWidget(
              feed: feedProvider.feeds[index],
              index: index,
            );
          },
        );
      },
    );
  }
}
