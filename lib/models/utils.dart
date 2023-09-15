T convertValue<T>(dynamic json, String key, bool required,
    {T? defaultValue = null}) {
  final value = json[key];
  if (value == null && defaultValue != null) {
    return defaultValue;
  } else if (required && value == null) {
    throw ArgumentError('${key} is required but is null');
  }

  if (T == String) {
    if (value == null) {
      return '' as T;
    }
    return value.toString() as T;
  } else if (T == int) {
    if (value == null) {
      return 0 as T;
    }
    return int.parse(value.toString()) as T;
  } else if (T == double) {
    if (value == null) {
      return 0.0 as T;
    }
    return double.parse(value.toString()) as T;
  } else if (T == bool) {
    if (value == null) {
      return false as T;
    }
    if (value is bool) {
      return value as T;
    }
    throw ArgumentError('Value is not of type bool');
  } else if (T == DateTime) {
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
