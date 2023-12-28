import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor;
  } else if (Platform.isAndroid) {
    const androidId = AndroidId();
    String? deviceId = await androidId.getId();
    return deviceId;
  }

  return "";
}
