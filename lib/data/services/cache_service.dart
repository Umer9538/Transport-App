import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheEntry {
  final String data;
  final DateTime cachedAt;
  final Duration ttl;

  CacheEntry({
    required this.data,
    required this.cachedAt,
    required this.ttl,
  });

  bool get isExpired => DateTime.now().difference(cachedAt) > ttl;

  Map<String, dynamic> toJson() => {
        'data': data,
        'cachedAt': cachedAt.millisecondsSinceEpoch,
        'ttlMs': ttl.inMilliseconds,
      };

  factory CacheEntry.fromJson(Map<String, dynamic> json) => CacheEntry(
        data: json['data'] as String,
        cachedAt: DateTime.fromMillisecondsSinceEpoch(json['cachedAt'] as int),
        ttl: Duration(milliseconds: json['ttlMs'] as int),
      );
}

class CacheService {
  static const String _prefix = 'cache_';

  // Default TTLs
  static const Duration userDataTTL = Duration(hours: 24);
  static const Duration tripsTTL = Duration(minutes: 30);
  static const Duration subscriptionTTL = Duration(hours: 6);
  static const Duration plansTTL = Duration(days: 7);

  // Cache keys
  static const String userDataKey = 'user_data';
  static const String upcomingTripsKey = 'upcoming_trips';
  static const String tripHistoryKey = 'trip_history';
  static const String subscriptionKey = 'subscription';
  static const String plansKey = 'plans';
  static const String scheduleKey = 'schedule';

  Future<void> put(String key, dynamic data, {Duration? ttl}) async {
    final prefs = await SharedPreferences.getInstance();
    final entry = CacheEntry(
      data: jsonEncode(data),
      cachedAt: DateTime.now(),
      ttl: ttl ?? tripsTTL,
    );
    await prefs.setString('$_prefix$key', jsonEncode(entry.toJson()));
  }

  Future<T?> get<T>(String key, T Function(dynamic json) fromJson) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;

    final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    if (entry.isExpired) {
      await remove(key);
      return null;
    }

    final decoded = jsonDecode(entry.data);
    return fromJson(decoded);
  }

  Future<List<T>?> getList<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;

    final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    if (entry.isExpired) {
      await remove(key);
      return null;
    }

    final decoded = jsonDecode(entry.data) as List;
    return decoded
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$key');
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  Future<bool> has(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return false;

    final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return !entry.isExpired;
  }

  Future<DateTime?> lastUpdated(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;

    final entry = CacheEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return entry.cachedAt;
  }
}
