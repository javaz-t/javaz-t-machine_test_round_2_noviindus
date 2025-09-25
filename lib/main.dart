import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/connection/network_info.dart';
import 'package:machine_test_round_2_noviindus/data/repository/auth_repository_impl.dart';
import 'package:machine_test_round_2_noviindus/data/services/auth_service.dart';
import 'package:machine_test_round_2_noviindus/data/services/home_api_service.dart';
import 'package:machine_test_round_2_noviindus/data/services/token_local_data_source.dart';
import 'package:machine_test_round_2_noviindus/domain/use_case/auth_use_case.dart';
import 'package:machine_test_round_2_noviindus/domain/use_case/get_home_feed.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/auth_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/category_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/feed_upload_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/home_feed_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/video_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/screens/home_screen.dart';
 import 'package:machine_test_round_2_noviindus/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'data/repository/category_repository_impl.dart';
import 'data/repository/feed_upload_repository_impl.dart';
import 'data/repository/home_repository_impl.dart';
import 'data/services/category_service.dart';
import 'data/services/feed_upload_service.dart';
import 'domain/use_case/get_category_use_case.dart';
import 'domain/use_case/upload_feed_use_case.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Auth Dependencies
    final authService = AuthService();
    final localDataSource = TokenLocalDataSource();
    final networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final authRepository = AuthRepositoryImpl(
      service: authService,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final verifyOtpUseCase = VerifyOtpUseCase(authRepository);

    // Category Dependencies
    final categoryApiService = CategoryApiService();
    final categoryRepository = CategoryRepositoryImpl(categoryApiService);
    final getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);

    // Home Feed Dependencies
    final homeApiService = HomeApiService();
    final homeRepository = HomeRepositoryImpl(homeApiService);
    final getHomeFeedsUseCase = GetHomeFeedsUseCase(homeRepository);
    final feedUploadService = FeedUploadService();
    final feedUploadRepository = FeedUploadRepositoryImpl(feedUploadService);
    final uploadFeedUseCase = UploadFeedUseCase(feedUploadRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(verifyOtpUseCase)),
        ChangeNotifierProvider(
          create: (context) =>
              CategoryProvider(getCategoriesUseCase)..fetchCategories(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeFeedProvider(getHomeFeedsUseCase,networkInfo),
        ),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(
          create: (_) => FeedUploadProvider(uploadFeedUseCase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Machine Test 2',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthScreen(),
      ),
    );
  }
}
