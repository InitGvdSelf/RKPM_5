// Helper type for Either pattern
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool isLeft;

  Either._(this._left, this._right, this.isLeft);

  factory Either.left(L value) => Either._(value, null, true);
  factory Either.right(R value) => Either._(null, value, false);

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (isLeft) {
      return onLeft(_left as L);
    } else {
      return onRight(_right as R);
    }
  }
}

