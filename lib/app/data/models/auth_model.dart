class Auth {
  int? statusCode;
  String? message;
  String? body;

  Auth({this.statusCode, this.message, this.body});

  Auth.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['body'] = body;
    return data;
  }
}
