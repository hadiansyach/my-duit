abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class OcrFailure extends Failure {
  const OcrFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
