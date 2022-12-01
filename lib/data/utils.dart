extension QueryParameterAdd on Map {
  addParam(key, value) {
    if (value != null) {
      this[key] = value;
    }
  }
}

extension ExtList on List {
  List<T> getNonNullItems<T>() =>
      this.takeWhile((value) => value != null).map<T>((e) => e!).toList();
}

extension ExtIteable on Iterable<Type?> {
  List<Type> getNonNullItems() =>
      this.takeWhile((value) => value != null).map((e) => e!).toList();
}
