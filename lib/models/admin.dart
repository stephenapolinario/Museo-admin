class LoggedAdmin {
  final String email, authCode;

  LoggedAdmin({
    required this.email,
    required this.authCode,
  });

  factory LoggedAdmin.fromJson(Map<String, dynamic> json) {
    return LoggedAdmin(
      authCode: json['token'],
      email: json['admin']['email'],
    );
  }
}

class ReadAdmin {
  final String id, email;

  ReadAdmin({
    required this.id,
    required this.email,
  });

  factory ReadAdmin.fromJson(Map<String, dynamic> json) {
    return ReadAdmin(
      id: json['_id'],
      email: json['email'],
    );
  }
}
