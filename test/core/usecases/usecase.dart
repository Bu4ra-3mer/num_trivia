import 'package:dartz/dartz.dart';
import 'package:num_trivia/core/errors/failures.dart';
import 'package:num_trivia/features/number_trivia/domain/entities/number_trivia.dart';


abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

