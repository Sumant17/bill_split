class MyUserModel {
  final String? id;
  final String name;
  final String email;
  MyUserModel({this.id, required this.name, required this.email});

  factory MyUserModel.fromJson(json) {
    return MyUserModel(
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
      };
}
