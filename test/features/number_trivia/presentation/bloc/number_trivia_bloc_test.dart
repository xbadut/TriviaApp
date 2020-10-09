import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/usecases/usecase.dart';
import 'package:trivia/core/utils/input_converter.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia/featrures/number_trivia/presentation/blocs/number_trivia/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreateNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTriva {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);

    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockConverterSuccess() =>
        when(mockInputConverter.stringToUsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test('should call the InputConverter to validate and convert', () async {
      setUpMockConverterSuccess();
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(mockInputConverter.stringToUsignedInteger(any));

      verify(mockInputConverter.stringToUsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      setUpMockConverterSuccess();
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      setUpMockConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailur()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      setUpMockConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailur()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

     test('should get data from the concrete use case', () async {

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
    

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForRandomNumber());
    });

     test('should emit [Loading, Error] when getting data fails', () async {
    

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailur()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailur()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
