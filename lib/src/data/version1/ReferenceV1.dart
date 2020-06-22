class ReferenceV1 {
  String id;
  String type;
  String name;

  ReferenceV1({String id, String type, String name})
      : id = id,
        type = type,
        name = name;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
  }

  factory ReferenceV1.fromJson(Map<String, dynamic> json) {
    var ref = ReferenceV1();
    ref.fromJson(json);
    return ref;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'type': type, 'name': name};
  }
}
