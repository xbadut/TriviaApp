import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/usecases/usecase.dart';
import 'package:trivia/core/utils/input_converter.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE =
    "Invalid Input - The number must be a positive integer or zero.";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreateNumberTrivia getConcreateNumberTrivia;
  final GetRandomNumberTriva getRandomNumberTriva;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    @required GetConcreateNumberTrivia concrete,
    @required GetRandomNumberTriva random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreateNumberTrivia = concrete,
        getRandomNumberTriva = random;

  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUsignedInteger(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield Loading();
        final failureOrTrivia =
            await getConcreateNumberTrivia(Params(number: integer));
        yield* _eitherLoadedOrErrorState(failureOrTrivia);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTriva(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }
}

Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> either) async* {
  yield either.fold(
    (failure) => Error(message: _mapFailureToMessage(failure)),
    (trivia) => Loaded(trivia: trivia),
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailur:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailur:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}
