import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/usecases/usecase.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreateNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreateNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute({
    @required int number,
  }) async {
    return await repository.getConcreateNumberTrivia(number);
  }

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreateNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  Params({@required this.number}): super([number]);
}