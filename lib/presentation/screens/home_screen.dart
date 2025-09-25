import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/constants/app_colors.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/navigation_extension.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';
import 'package:machine_test_round_2_noviindus/presentation/screens/add_feeds_screen.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/category_list.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_text.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/feed_items.dart';
import 'package:provider/provider.dart';

import '../providers/home_feed_provider.dart';

class HomeScreen extends StatefulWidget {
  // Changed to StatelessWidget
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatients();
    });
  }

  Future<void> _loadPatients() async {
    final homeFeedProvider = context.read<HomeFeedProvider>();
    await homeFeedProvider.fetchHomeFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          pushToScreen(AddFeedPage(), context);
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.accentRed,
          child: Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
      backgroundColor: AppColors.primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            63.vs(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: CustomText(
                        text: 'Hello Maria',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    11.vs(),
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: CustomText(
                        text: 'Welcome back to Section',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: CircleAvatar(child: Icon(Icons.person)),
                ),
              ],
            ),
            32.vs(),

            const CategoryList(),

            Consumer<HomeFeedProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Center(child: Text('Error: ${provider.errorMessage}'));
                }
                if (provider.feeds.isEmpty) {
                  return const Center(child: Text('No feeds available.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: provider.feeds.length,
                  itemBuilder: (context, index) {
                    final feed = provider.feeds[index];
                    return FeedItemWidget(feed: feed, index: index);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
