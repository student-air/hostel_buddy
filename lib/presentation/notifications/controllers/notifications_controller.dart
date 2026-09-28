import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type, // bid | offer | system | chat
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final String time;
  final String type;
  bool isRead;

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      type: map['type']?.toString() ?? 'system',
      isRead: map['isRead'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'time': time,
      'type': type,
      'isRead': isRead,
    };
  }
}

class NotificationsController extends GetxController {
  final _box = GetStorage();
  final notifications = <AppNotification>[].obs;
  final selectedTab = 0.obs; // 0 = All, 1 = Unread

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final raw = (_box.read('app_notifications') as List?) ?? [];
    if (raw.isEmpty) {
      // seed demo data once
      notifications.assignAll([
        AppNotification(
          id: '1',
          title: 'New offer received',
          body: 'Green Valley Hostel offered Rs 11,500/mo on your 3 Seater bid.',
          time: '2m ago',
          type: 'offer',
        ),
        AppNotification(
          id: '2',
          title: 'Bid placed successfully',
          body: 'Your bid for 2 Seater at Rs 13,000/mo is now live.',
          time: '1h ago',
          type: 'bid',
          isRead: true,
        ),
        AppNotification(
          id: '3',
          title: 'Offer expiring soon',
          body: 'Campus View Lodge offer ends in 2 hours. Review now.',
          time: '3h ago',
          type: 'offer',
        ),
        AppNotification(
          id: '4',
          title: 'Welcome to Hostel Buddy',
          body: 'Complete your profile to get better matches.',
          time: '1d ago',
          type: 'system',
          isRead: true,
        ),
      ]);
      _save();
    } else {
      notifications.assignAll(
        raw.map((e) => AppNotification.fromMap(Map<String, dynamic>.from(e as Map))),
      );
    }
  }

  List<AppNotification> get filtered {
    if (selectedTab.value == 1) {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications.toList();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void onTabChanged(int index) => selectedTab.value = index;

  void markAsRead(AppNotification item) {
    final i = notifications.indexWhere((n) => n.id == item.id);
    if (i == -1) return;
    notifications[i].isRead = true;
    notifications.refresh();
    _save();
  }

  void markAllRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    _save();
  }

  void deleteNotification(AppNotification item) {
    notifications.removeWhere((n) => n.id == item.id);
    notifications.refresh();
    _save();
  }

  void _save() {
    _box.write(
      'app_notifications',
      notifications.map((e) => e.toMap()).toList(),
    );
  }
}