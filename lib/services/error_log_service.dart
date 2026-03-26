import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class ErrorLogService {
  final SupabaseClient _supabase;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  ErrorLogService(this._supabase);

  Future<void> logError({
    required String message,
    required String? stackTrace,
    String? userId,
  }) async {
    // Só envia logs para o Supabase se o app estiver em modo Release (Produção)
    if (!kReleaseMode) {
      if (kDebugMode) {
        print('Debug mode: Skip logging error to Supabase: $message');
      }
      return;
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfoMap = await _getDeviceInfo();

      await _supabase.from('error_logs').insert({
        'user_id': userId,
        'error_message': message,
        'stack_trace': stackTrace,
        'app_version': '${packageInfo.version}+${packageInfo.buildNumber}',
        'device_info': deviceInfoMap,
      });

      if (kDebugMode) {
        print('Error logged to Supabase: $message');
      }
    } catch (e) {
      // Evitar loop infinito se o log falhar
      if (kDebugMode) {
        print('Failed to log error to Supabase: $e');
      }
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'platform': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'os_version': androidInfo.version.release,
          'sdk_intl': androidInfo.version.sdkInt,
          'is_emulator': !androidInfo.isPhysicalDevice,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'platform': 'iOS',
          'model': iosInfo.utsname.machine,
          'system_name': iosInfo.systemName,
          'os_version': iosInfo.systemVersion,
          'is_emulator': !iosInfo.isPhysicalDevice,
        };
      }
      return {'platform': 'Unknown'};
    } catch (e) {
      return {'error': 'Could not get device info: $e'};
    }
  }
}
