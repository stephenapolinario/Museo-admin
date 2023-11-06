class User {
  String id,
      name,
      lastName,
      email,
      cpf,
      birthday,
      phoneNumber,
      cep,
      state,
      city,
      neighborhood,
      address,
      number,
      complement,
      picture;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.cpf,
    required this.birthday,
    required this.phoneNumber,
    required this.cep,
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.address,
    required this.number,
    required this.complement,
    required this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      cpf: json['cpf'],
      birthday: json['birthday'],
      phoneNumber: json['phoneNumber'],
      cep: json['cep'],
      state: json['state'],
      city: json['city'],
      neighborhood: json['neighborhood'],
      address: json['address'],
      number: json['number'],
      complement: json['complement'],
      picture: json['picture'],
    );
  }
}
