import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/core/platform/network_info.dart';

class MockDataConnectionChecker extends Mock
  implements DataConnectionChecker {}

void main() {
  NetworkInfo networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp((){
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',() async {
      final tHasConnectionFuture = Future.value(true);

      when(mockDataConnectionChecker.hasConnection)
      .thenAnswer((_) => tHasConnectionFuture);

      final result = networkInfo.isConnected;

      verify(mockDataConnectionChecker.hasConnection);

      expect(result, tHasConnectionFuture);
    });
  });
}