import 'package:trackless/main.dart';
import 'package:trackless/models/work.dart';
import 'package:intl/intl.dart';

class WorkStorage {
  void saveWorkOverride(List<Work> work) async {
    print('WorkStorage: saving work');

    // Sort the work by date
    List<Work> tmp = new List<Work>();
    List<List<Work>> parcedWork = new List<List<Work>>();
    String lastDate;

    work.forEach((element) {
      if (lastDate != element.date) {
        // Update the lastDate push tmp to parcedWork and clean the tmp
        lastDate = element.date;
        if (tmp.length > 0) {
          parcedWork.add(tmp);
        }
        tmp = new List<Work>();
      }

      tmp.add(element);
    });

    // Add the last
    parcedWork.add(tmp);

    // Save the work
    if (parcedWork[0].length > 0) {
      parcedWork.forEach((element) {
        storage.setItem(element[0].date, element);
      });
    }
  }

  List<Work> loadWork(DateTime startDate, DateTime endDate) {
    List<Work> tmp = [];
    DateTime tmpDate = endDate;

    // Make sure to load the last day first
    while (!tmpDate.isBefore(startDate)) {
      // Load work for each date
      final List<dynamic> jsonList =
          storage.getItem(new DateFormat('yyyy-MM-dd').format(tmpDate));

      if (jsonList != null) {
        jsonList.forEach((element) {
          tmp.add(Work.fromJson(element));
        });
      }

      // Go to the next date
      tmpDate = tmpDate.subtract(Duration(days: 1));
    }

    return tmp;
  }
}
