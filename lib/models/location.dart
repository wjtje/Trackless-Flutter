class Location {
  final int locationID;
  final String place;
  final String name;
  final String id;

  Location({this.locationID, this.place, this.name, this.id})
      : assert(locationID != null),
        assert(place != null),
        assert(name != null),
        assert(id != null);

  // Convert from json
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        locationID: json['locationID'],
        place: json['place'],
        name: json['name'],
        id: json['id']);
  }

  // Convert to json
  Map<String, dynamic> toJson() {
    return {
      "locationID": this.locationID,
      "place": this.place,
      "name": this.name,
      "id": this.id
    };
  }
}
