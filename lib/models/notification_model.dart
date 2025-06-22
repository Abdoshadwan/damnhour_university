class NotificationModel {
  int? id;
  String? title;
  String? message;
  String? created_at;
  bool? is_read;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.created_at,
    this.is_read,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    created_at = json['created_at'];
    is_read = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'created_at': created_at,
      'is_read': is_read,
    };
  }
}
