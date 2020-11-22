import 'package:trackless/main.dart';
import 'package:trackless/models/work.dart';
import 'package:intl/intl.dart';

class WorkStorage {
  void saveWorkOverride(List<Work> work, DateTime startDate, DateTime endDate) async {
    print('WorkStorage: saving work');

    // Clean the localStorage
    DateTime workingDate = startDate;

    while (workingDate.isBefore(endDate)) {
      storage.setItem(new DateFormat('yyyy-MM-dd').format(workingDate), []);
      workingDate = workingDate.add(Duration(days: 1));
    }

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

  /// Save a new work object
  Future<void> saveWork(Work work) async {
    print('WorkStorage: saving work');
    List<Work> tmp = new List<Work>();

    // Get all the other work on that date
    final List<dynamic> jsonList = storage.getItem(work.date);

    if (jsonList != null) {
      jsonList.forEach((element) {
        tmp.add(Work.fromJson(element));
      });
    }

    // Add the new work
    tmp.add(work);

    // Save the changes
    await storage.setItem(work.date, tmp);
  }

  /// Change a new work object
  Future<void> updateWork(Work work, DateTime orgDate) async {
    print('WorkStorage: updating work');

    final String oldDate = '${orgDate.year}-${orgDate.month}-${orgDate.day}';

    List<Work> tmp = new List<Work>();

    // Get all the work on the org date
    final List<dynamic> jsonList = storage.getItem(oldDate);

    if (oldDate == work.date) {
      if (jsonList != null) {
        jsonList.forEach((element) {
          final Work w = Work.fromJson(element);

          // Insert the new one
          if (w.workID == work.workID) {
            tmp.add(work);
          } else {
            tmp.add(w);
          }
        });
      }

      // Save the changes
      await storage.setItem(work.date, tmp);
    } else {
      // Changed date
      if (jsonList != null) {
        jsonList.forEach((element) {
          final Work w = Work.fromJson(element);

          // Remove the edited work
          if (w.workID != work.workID) {
            tmp.add(w);
          }
        });
      }

      // Save the changes
      await storage.setItem(oldDate, tmp);
      await saveWork(work);
    }
  }

  Future<void> removeWork(Work work, DateTime orgDate) async {
    print('WorkStorage: removing work');

    final String oldDate = '${orgDate.year}-${orgDate.month}-${orgDate.day}';

    List<Work> tmp = new List<Work>();

    // Get all the work on the org date
    final List<dynamic> jsonList = storage.getItem(oldDate);

    if (jsonList != null) {
      jsonList.forEach((element) {
        final Work w = Work.fromJson(element);

        // Remove the correct one
        if (w.workID != work.workID) {
          tmp.add(w);
        }
      });
    }

    // Save the changes
    await storage.setItem(oldDate, tmp);
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
