T convertValue<T>(dynamic json, String key, bool required,
    {T? defaultValue = null}) {
  bool isTypeOf<T, V, Z>() => T == V || T == Z;

  final value = json[key];
  if (value == null) {
    if (defaultValue != null) {
      return defaultValue;
    } else if (required) {
      throw ArgumentError('${key} is required but is null');
    } else if (!required) {
      return null as T;
    }
  }
  if (isTypeOf<T, String, String?>()) {
    if (value == null) {
      return '' as T;
    }
    return value.toString() as T;
  } else if (isTypeOf<T, int, int?>()) {
    if (value == null) {
      return 0 as T;
    }
    return int.parse(value.toString()) as T;
  } else if (isTypeOf<T, double, double?>()) {
    if (value == null) {
      return 0.0 as T;
    }
    return double.parse(value.toString()) as T;
  } else if (isTypeOf<T, bool, bool?>()) {
    if (value == null) {
      return false as T;
    } else if (value is bool) {
      return value as T;
    } else if (value == "true") {
      return true as T;
    } else if (value == "false") {
      return false as T;
    }
    throw ArgumentError('Value is not of type bool');
  } else if (isTypeOf<T, DateTime, DateTime?>()) {
    if (value == null) {
      return DateTime.fromMillisecondsSinceEpoch(0) as T;
    }
    try {
      return DateTime.parse(value.toString()) as T;
    } catch (e) {
      throw ArgumentError('Failed to parse DateTime from value');
    }
  } else {
    throw ArgumentError('Unsupported type: ${T.toString()}');
  }
}
