import 'package:firebase_crashlytics/firebase_crashlytics.dart';

bool isTypeOf<T, V, Z>() => T == V || T == Z;

T convertToType<T>(
  dynamic value,
) {
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
  } else if (isTypeOf<T, List<String>, List<String>?>()) {
    return (value as List).cast<String>() as T;
  } else if (isTypeOf<T, List<Map<String, String>>,
      List<Map<String, String>>?>()) {
    return (value as List)
        .map((i) => Map<String, String>.from(i as Map))
        .toList() as T;
  } else {
    throw ArgumentError('Unsupported type: ${T.toString()}');
  }
}

List<T> convertList<T>(dynamic value, {List<T>? defaultValue = const []}) {
  if (null is T) {
    return defaultValue as List<T>;
  }
  return (value as List).map((v) => convertToType<T>(v)).toList();
}

T convertValue<T>(dynamic json, String key, bool required,
    {T? defaultValue = null}) {
  final value = json[key];
  if (value == null) {
    if (defaultValue != null) {
      return defaultValue;
    } else if (required) {
      FirebaseCrashlytics.instance.recordError(
          Exception('${key} is required but is null'), StackTrace.current);
      throw Exception('${key} is required but is null');
    } else if (!required) {
      return null as T;
    }
  }

  return convertToType<T>(value);
}

abstract class Identifiable {
  int get id;
}
