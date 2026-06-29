// unread_count_model.dart

class UnreadCountResponse {
  final bool status;
  final String message;
  final UnreadCountData data;

  UnreadCountResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: UnreadCountData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class UnreadCountData {
  final int unreadCount;

  UnreadCountData({required this.unreadCount});

  factory UnreadCountData.fromJson(Map<String, dynamic> json) {
    return UnreadCountData(
      unreadCount: json['unread_count'] as int,
    );
  }
}