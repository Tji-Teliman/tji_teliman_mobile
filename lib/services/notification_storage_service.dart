import 'package:shared_preferences/shared_preferences.dart';

/// Gestion locale des notifications vues pour contourner le marquage automatique du backend.
class NotificationStorageService {
  static const String _seenKeyPrefix = 'notification_seen_';

  static Future<void> markNotificationAsSeen(int notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_seenKeyPrefix$notificationId', true);
    } catch (e) {
      // Ignore silently; logs peuvent être ajoutés si besoin.
    }
  }

  static Future<void> markNotificationsAsSeen(List<Map<String, dynamic>> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final notif in notifications) {
        final idAny = notif['id'];
        if (idAny == null) continue;
        final id = idAny is int ? idAny : int.tryParse(idAny.toString());
        if (id == null) continue;
        await prefs.setBool('$_seenKeyPrefix$id', true);
      }
    } catch (e) {
      // Ignore errors.
    }
  }

  static Future<void> markAllCurrentNotificationsAsSeen(List<Map<String, dynamic>> notifications) async {
    await markNotificationsAsSeen(notifications);
  }

  static Future<bool> isNotificationSeenLocally(int notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_seenKeyPrefix$notificationId') ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_seenKeyPrefix)).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      // Ignore.
    }
  }
}

