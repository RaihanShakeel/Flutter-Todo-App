class Task{
  String title;
  DateTime timeStamp;
  bool done;

  Task({
    required this.title,
    required this.timeStamp,
    required this.done,
  });

  factory Task.fromMap(Map task){
    return Task(
      title: task['title'],
      timeStamp: task['timeStamp'],
      done: task['done'],
    );
  }

  Map toMap(){
    return {
      "title": title,
      "timeStamp": timeStamp,
      "done": done,
    };
  }
}