// lib/core/utils/logging_mixin.dart
import 'dart:developer' as developer;

mixin LoggingMixin {
  void logDataStorage(String key, dynamic value, {String? source}) {
    developer.log(
      'Data Storage: Storing data',
      name: 'SharedPreferences',
      time: DateTime.now(),
      error: {
        'key': key,
        'value': value,
        'source': source ?? 'Unknown',
      },
    );
  }

  void logDataRetrieval(String key, dynamic value, {String? source}) {
    developer.log(
      'Data Storage: Retrieving data',
      name: 'SharedPreferences',
      time: DateTime.now(),
      error: {
        'key': key,
        'value': value,
        'source': source ?? 'Unknown',
      },
    );
  }

  void logDataDeletion(String key, {String? source}) {
    developer.log(
      'Data Storage: Deleting data',
      name: 'SharedPreferences',
      time: DateTime.now(),
      error: {
        'key': key,
        'source': source ?? 'Unknown',
      },
    );
  }
}
