class UserLikes {
  int? id;
  int? user;
  int? S_cId;
  String? type;
  DateTime? createdAt;
  String? message;

  UserLikes({
    required this.id,
    required this.user,
    required this.S_cId,
    required this.type,
    required this.createdAt,
    required this.message,
  });

  UserLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    S_cId = json['sc_type'];
    type = json['type'];
    createdAt = DateTime.parse(json['created_at']);
    message = json['message'];
  }
}
