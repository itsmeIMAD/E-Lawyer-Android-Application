class Task {
  bool completed = false;
  var title = '';
  var description = '';
  DateTime date;
  int id = 0;

  Task(
      {required this.completed,
      required this.title,
      required this.description,
      required this.date,
      required this.id});
}
