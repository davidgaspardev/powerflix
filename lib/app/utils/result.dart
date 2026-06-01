abstract class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.error(Exception exception) = Error;
}

class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

class Error<T extends Exception> extends Result<T> {
  const Error(this.value);

  final Exception value;

  @override
  String toString() => 'Result<$T>.error($value)';
}