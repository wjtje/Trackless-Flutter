import 'package:trackless/main.dart';
import 'package:trackless/models/location.dart';

class LocationStorage {
  void saveLocationOverride(List<Location> location) async {
    print('LocationStorage: saving location');

    storage.setItem('location', location);
  }

  List<Location> loadLocation() {
    List<Location> tmp = [];
    final List<dynamic> jsonList = storage.getItem('location');

    if (jsonList != null) {
      jsonList.forEach((element) {
        tmp.add(Location.fromJson(element));
      });
    }

    return tmp;
  }
}
