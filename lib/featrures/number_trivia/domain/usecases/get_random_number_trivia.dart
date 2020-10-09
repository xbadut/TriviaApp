import 'package:trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia/core/usecases/usecase.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/featrures/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTriva extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTriva(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }


}