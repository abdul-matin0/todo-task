class Task{

  final int id;
  final String title;
  final String description;

  Task({this.id, this.title, this.description});

  // convert task object to a map (key type = string and value = dynamic)
  // key should be same with database columns
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'description' : description,
    };  //return a map
  }
}