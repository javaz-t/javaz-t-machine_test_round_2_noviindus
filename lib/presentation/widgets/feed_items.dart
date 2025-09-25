import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/feed_entity.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/video_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';
import 'custom_text.dart';

class FeedItemWidget extends StatelessWidget {
  final FeedEntity feed;
  final int index;

  const FeedItemWidget({super.key, required this.feed, required this.index});

  @override
  Widget build(BuildContext context) {

    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {

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
              child: CustomText(fontSize: 12,fontWeight: FontWeight.w300,text:  feed.description),
            ),

          ],
        );
      },
    );
  }

 }
