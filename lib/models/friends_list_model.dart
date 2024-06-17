class FriendsListModel {
  final String friendname;

  FriendsListModel({required this.friendname});

  factory FriendsListModel.fromJson(Map<String, dynamic> json) {
    return FriendsListModel(friendname: json['friendname']);
  }

  Map<String, dynamic> toJson() {
    return {
      "friendname": friendname,
    };
  }
}
