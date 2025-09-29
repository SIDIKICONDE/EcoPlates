import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Interface de base pour tous les use cases
/// 
/// Suit le principe Single Responsibility
/// Chaque use case a une seule responsabilité
typedef UseCase<T, Params> = Future<Either<Failure, T>> Function(Params params);

/// Use case sans paramètres
typedef NoParamsUseCase<T> = Future<Either<Failure, T>> Function();

/// Paramètres vides pour les use cases qui n'en ont pas besoin
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Use case pour les streams
typedef StreamUseCase<T, Params> = Stream<Either<Failure, T>> Function(Params params);
