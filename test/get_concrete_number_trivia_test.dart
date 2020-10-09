
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/core/usecases/usecase.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockNumberTriviaRepository extends Mock
  implements NumberTriviaRepository {}


void main() {
  GetRandomNumberTriva usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTriva(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test(
    'should get trivia for the number from the repository',
    () async {
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
      .thenAnswer((_) async => Right(tNumberTrivia));

      final result = await usecase(NoParams());

      expect(result, Right(tNumberTrivia));

      verify(mockNumberTriviaRepository.getRandomNumberTrivia());

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    }
  );

}