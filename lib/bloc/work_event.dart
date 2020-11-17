import 'package:trackless/models/work.dart';

abstract class WorkEvent {}

class LoadWorkFromServer extends WorkEvent {}

class AddWork extends WorkEvent {
  final Work work;

  AddWork(this.work);
}
