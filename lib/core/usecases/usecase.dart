/// Basic UseCase class for Clean Architecture
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// NoParams class for use cases that don't require parameters
class NoParams {}
