import 'package:trackless/main.dart';
import 'package:trackless/models/worktype.dart';

class WorktypeStorage {
  void saveWorktypeOverride(List<Worktype> worktype) async {
    print('WorktypeStorage: saving worktype');

    storage.setItem('worktype', worktype);
  }

  List<Worktype> loadWorktype() {
    List<Worktype> tmp = [];
    final List<dynamic> jsonList = storage.getItem('worktype');

    if (jsonList != null) {
      jsonList.forEach((element) {
        tmp.add(Worktype.fromJson(element));
      });
    }

    return tmp;
  }
}
