class GroupsModel {
  final String? groupid;
  final String groupname;
  final String imagepath;
  final List<String> names;

  GroupsModel(
      {this.groupid,
      required this.groupname,
      required this.imagepath,
      required this.names});

  factory GroupsModel.fromJson(Map<String, dynamic> json) {
    return GroupsModel(
      groupname: json['groupname'],
      imagepath: json['imagepath'],
      names: List<String>.from(json['names']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "groupname": groupname,
      "imagepath": imagepath,
      "names": names,
    };
  }
}
