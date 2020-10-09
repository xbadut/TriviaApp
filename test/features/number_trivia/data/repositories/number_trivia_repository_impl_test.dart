import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/core/error/exception.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/platform/network_info.dart';
import 'package:trivia/featrures/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/featrures/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/featrures/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/featrures/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel(text: "test trivia", number: tNumber);
  final NumberTrivia tNumberTrivia = tNumberTriviaModel;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  void runTestOnine(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
    });

    body();
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
    });

    body();
  }

  group('getConcreateNunmberTivia', () {
    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getConcreateNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });
  });

  runTestOnine(() {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getConcreNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);

      final result = await repository.getConcreateNumberTrivia(tNumber);

      verify(mockRemoteDataSource.getConcreNumberTrivia(tNumber));
      expect(result, equals((Right(tNumberTrivia))));
    });

    test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getConcreNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);

      await repository.getConcreateNumberTrivia(tNumber);

      verify(mockRemoteDataSource.getConcreNumberTrivia(tNumber));
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getConcreNumberTrivia(tNumber))
          .thenThrow(ServerException());

      final result = await repository.getConcreateNumberTrivia(tNumber);

      verify(mockRemoteDataSource.getConcreNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailur())));
    });
  });


    runTestOffline((){
    test(
        'should return last locally cached data when the cached data is present',
        () async {
      final result = await repository.getConcreateNumberTrivia(tNumber);

      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('should return CacheFailure when there is no cached data present',
        () async {
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

      final result = await repository.getConcreateNumberTrivia(tNumber);
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailur())));
    });
  });
}
