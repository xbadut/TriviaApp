import 'package:dartz/dartz.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreateNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();

}