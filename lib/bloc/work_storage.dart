import 'package:trackless/main.dart';
import 'package:trackless/models/work.dart';
import 'package:intl/intl.dart';

class WorkStorage {
  Future<void> saveWorkOverride(
      List<Work> work, DateTime startDate, DateTime endDate) async {
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

    // Keep track of the dates
    Set<String> changedDates = {};

    // Save the work
    if (parcedWork[0].length > 0) {
      int index = 0;

      while (parcedWork.length > index) {
        // Keep track of the date
        print('WorkStorage: setting: ${parcedWork[index][0].date}');
        changedDates.add(parcedWork[index][0].date);

        // Save it in localStorage
        await storage.setItem(parcedWork[index][0].date, parcedWork[index]);
        index++;
      }
    }

    // Remove old dates
    DateTime workingDate = startDate;

    while (workingDate.compareTo(endDate) < 0) {
      // Is workingDate bevore or equal to endDate
      String date = new DateFormat('yyyy-MM-dd').format(workingDate);

      // Only remove dates that aren't changed
      if (!changedDates.contains(date)) {
        print(
            'workStorage: cleaning ${new DateFormat('yyyy-MM-dd').format(workingDate)}');
        await storage
            .deleteItem(new DateFormat('yyyy-MM-dd').format(workingDate));
      }

      workingDate = workingDate.add(Duration(days: 1));
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

    final String oldDate = DateFormat('yyyy-MM-dd').format(orgDate);

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

    final String oldDate = DateFormat('yyyy-MM-dd').format(orgDate);

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
    DateTime tmpDate = startDate;

    // Make sure to load the last day first
    while (!tmpDate.isAfter(endDate)) {
      // Load work for each date
      final List<dynamic> jsonList =
          storage.getItem(new DateFormat('yyyy-MM-dd').format(tmpDate));

      if (jsonList != null) {
        jsonList.forEach((element) {
          tmp.add(Work.fromJson(element));
        });
      }

      // Go to the next date
      tmpDate = tmpDate.add(Duration(days: 1));
    }

    return tmp;
  }
}
