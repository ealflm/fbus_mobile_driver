class Notification {
  String? title;
  String? content;
  DateTime? createdDate;
  int? filter;

  Notification({
    this.title,
    this.content,
    this.createdDate,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    createdDate = DateTime.parse(json['createdDate']);
  }
}
