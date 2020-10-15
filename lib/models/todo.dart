class Todo{
  final int id;
  final int taskId;
  final String title;
  final int isDone;

  Todo({this.isDone, this.title, this.id, this.taskId});

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'isDone' : isDone,
      'taskId' : taskId,
    };
  }
}