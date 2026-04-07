/// A generic Result class that can represent success or failure.
/// The `E` type is used for error (ApiErrorResponse or AppError)
class Result<T, E> {
  final T? data;
  final E? error;

  bool get isSuccess => data != null && error == null;
  bool get isFailure => error != null;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;
}
