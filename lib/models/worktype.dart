class Worktype {
  final int worktypeID;
  final String name;

  Worktype({this.worktypeID, this.name})
      : assert(worktypeID != null),
        assert(name != null);

  // Convert from json
  factory Worktype.fromJson(Map<String, dynamic> json) {
    return Worktype(worktypeID: json['worktypeID'], name: json['name']);
  }

  // Convert to json
  Map<String, dynamic> toJson() {
    return {'worktypeID': this.worktypeID, 'name': this.name};
  }
}
