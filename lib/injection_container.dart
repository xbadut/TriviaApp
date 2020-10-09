import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/core/platform/network_info.dart';
import 'package:trivia/featrures/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/featrures/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/featrures/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia/featrures/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia/featrures/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:http/http.dart' as http;
import 'core/utils/input_converter.dart';
import 'featrures/number_trivia/presentation/blocs/number_trivia/number_trivia_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));

  //Singleton

  //Use Cases
  sl.registerLazySingleton(() => GetConcreateNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriva(sl()));

  //Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkImpl(sl()));

  //Repo
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //Data source
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));


  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
