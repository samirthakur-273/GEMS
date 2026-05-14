// import 'package:device_info/device_info.dart';
// import 'package:flutter/services.dart';
// import 'package:location/location.dart';

// class DeviceDetails {
  
//   static const MethodChannel _channel2 = const MethodChannel('imei_plugin');

//   static Future<LocationData> checklocation() {
//     var location = new Location();
//     return location.getLocation();
//   }

//   static Future<AndroidDeviceInfo> androidinfo() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     return deviceInfo.androidInfo;
//   }

//   static Future<IosDeviceInfo> iosinfo() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     return deviceInfo.iosInfo;
//   }

//   static Future<String> getImei() async {
//     var deviceimei = await _channel2.invokeMethod('getImei');
//     return deviceimei;
//   }
// }
