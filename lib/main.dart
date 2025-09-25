import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:machine_test_round_2_noviindus/core/connection/network_info.dart';
import 'package:machine_test_round_2_noviindus/data/repository/auth_repository_impl.dart';
import 'package:machine_test_round_2_noviindus/data/services/auth_service.dart';
import 'package:machine_test_round_2_noviindus/data/services/token_local_data_source.dart';
import 'package:machine_test_round_2_noviindus/domain/use_case/auth_use_case.dart';
import 'package:machine_test_round_2_noviindus/presentation/providers/auth_provider.dart';
import 'package:machine_test_round_2_noviindus/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final localDataSource = TokenLocalDataSource();
    final networkInfo = NetworkInfoImpl(DataConnectionChecker());

    final authRepository = AuthRepositoryImpl(
      service: authService,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final verifyOtpUseCase = VerifyOtpUseCase(authRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(verifyOtpUseCase)),
      ],
      child: MaterialApp(
        title: 'Flutter Machine Test 2',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthScreen(),
      ),
    );
  }
}
