import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/constants/app_colors.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/navigation_extension.dart';
import 'package:machine_test_round_2_noviindus/core/extensions/sized_box_extension.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/video_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/screens/feed_upload_screen.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/category_list.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_shimmer.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/custom_text.dart';
import 'package:machine_test_round_2_noviindus/presentation/widgets/feed_items.dart';
import 'package:provider/provider.dart';
import '../providers/home_feed_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHomeFeeds();
    });
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadHomeFeeds() async {
    final homeFeedProvider = context.read<HomeFeedProvider>();
    await homeFeedProvider.fetchHomeFeeds();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeFeedProvider>();

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showExitConfirmationDialog(context);
         return shouldExit ?? false;
      },
      child: Scaffold(
        floatingActionButton:
            provider.isNetWorkDown || provider.errorMessage != null
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: () {
                  pushToScreen(FeedUploadScreen(), context);
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.accentRed,
                  child: const Icon(Icons.add, color: Colors.white, size: 40),
                ),
              ),
        backgroundColor: AppColors.primaryBackground,
        body: Consumer<HomeFeedProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const CustomShimmer();
            }
            if (provider.isNetWorkDown) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please Check Your Internet !! ",
                      style: const TextStyle(color: Colors.red),
                    ),
                    TextButton(
                      onPressed: () async {
                        _loadHomeFeeds();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (provider.isNetWorkDown) {
              return Center(
                child: Text(
                  "Please Check Your Internet",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await _loadHomeFeeds();
              },
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
                          const Padding(
                            padding: EdgeInsets.only(left: 17),
                            child: CustomText(
                              text: 'Hello Maria',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          11.vs(),
                          const Padding(
                            padding: EdgeInsets.only(left: 17),
                            child: CustomText(
                              text: 'Welcome back to Section',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 17),
                        child: CircleAvatar(child: Icon(Icons.person)),
                      ),
                    ],
                  ),
                  32.vs(),

                  const CategoryList(),

                  Expanded(
                    child: Consumer<HomeFeedProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const CustomShimmer();
                        }
                        if (provider.errorMessage != null) {
                          return Center(
                            child: Text('Error: ${provider.errorMessage}'),
                          );
                        }
                        if (provider.feeds.isEmpty) {
                          return const Center(
                            child: Text('No feeds available.'),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          itemCount: provider.feeds.length,
                          itemBuilder: (context, index) {
                            final feed = provider.feeds[index];
                            return FeedItemWidget(feed: feed, index: index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onScroll() {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 2;
    final offset = _scrollController.offset;
    final firstVisible = (offset / itemWidth).floor();

    context.read<VideoProvider>().updateVideoIndex(firstVisible);
  }

  Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Exit'),
          content: const Text('Are you sure you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true), // Exit
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
