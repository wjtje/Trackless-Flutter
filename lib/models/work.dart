import 'location.dart';
import 'user.dart';
import 'worktype.dart';

class Work {
  final int workID;
  final double time;
  final String date;
  final String description;
  final Location location;
  final User user;
  final Worktype worktype;

  Work(
      {this.workID,
      this.time,
      this.description,
      this.date,
      this.location,
      this.user,
      this.worktype})
      : assert(workID != null),
        assert(time != null),
        assert(description != null),
        assert(date != null),
        assert(location != null),
        assert(user != null),
        assert(worktype != null);

  // Convert from json
  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
        workID: json['workID'],
        time: double.parse(json['time'].toString()),
        date: json['date'],
        description: json['description'],
        location: Location.fromJson(json['location']),
        user: User.fromJson(json['user']),
        worktype: Worktype.fromJson(json['worktype']));
  }

  // Convert to json
  Map<String, dynamic> toJson() {
    return {
      "workID": this.workID,
      "time": this.time.toString(),
      "date": this.date,
      "description": this.description,
      "location": this.location.toJson(),
      'user': this.user.toJson(),
      'worktype': this.worktype.toJson()
    };
  }
}
