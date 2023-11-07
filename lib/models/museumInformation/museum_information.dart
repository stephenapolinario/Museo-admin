class MuseumPhone {
  String id, phoneNumber;

  MuseumPhone({
    required this.id,
    required this.phoneNumber,
  });

  factory MuseumPhone.fromJson(Map<String, dynamic> json) {
    return MuseumPhone(
      id: json['_id'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class MuseumEmail {
  String id, email;

  MuseumEmail({
    required this.id,
    required this.email,
  });

  factory MuseumEmail.fromJson(Map<String, dynamic> json) {
    return MuseumEmail(
      id: json['_id'],
      email: json['email'],
    );
  }
}

class MuseumInformation {
  String country, state, id;
  final List<MuseumPhone> phoneList;
  final List<MuseumEmail> emailList;

  MuseumInformation({
    required this.id,
    required this.country,
    required this.state,
    required this.emailList,
    required this.phoneList,
  });

  factory MuseumInformation.fromJson(Map<String, dynamic> json) {
    var phoneData = json['phoneNumberList'] as List<dynamic>;
    var emailData = json['emailList'] as List<dynamic>;

    List<MuseumEmail> emailDataList = emailData
        .map(
          (emailJson) => MuseumEmail(
            id: emailJson['_id'],
            email: emailJson['email'],
          ),
        )
        .toList();

    List<MuseumPhone> phoneDataList = phoneData
        .map(
          (phoneNumberJson) => MuseumPhone(
            id: phoneNumberJson['_id'],
            phoneNumber: phoneNumberJson['phoneNumber'],
          ),
        )
        .toList();

    return MuseumInformation(
      id: json['_id'],
      country: json['country'],
      state: json['state'],
      emailList: emailDataList,
      phoneList: phoneDataList,
    );
  }
}
