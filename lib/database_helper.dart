import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_task/models/task.dart';
import 'package:todo_task/models/todo.dart';

class DatabaseHelper {
  // connect to database i.e. open database
  Future<Database> database() async {
    return openDatabase(
      // create database
      join(await getDatabasesPath(), 'todo.db'),

      // create table
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");

        return db;
      }, // onCreate method

      version: 1,
    );
    // end of openDatabase
  }

  // update tasks
  Future<void> updateTaskTitle (String title, int id) async{
    Database _db = await database();
    
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id' ");
  }

  // update description
  Future<void> updateTaskDescription (int id, String description) async{
    Database _db = await database();

    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id' ");
  }

  // insert values as map to tasks table
  Future<int> insertTask(Task task) async {

    int taskId = 0;
    Database _db = await database();

    await _db.insert("tasks", task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
          taskId = value;
    });

    return taskId;
  }

  // insert values as map to to-do table
  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();

    await _db.insert("todo", todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  // fetch values from database
  Future<List<Task>> getTasks() async {
    Database _db = await database();

    //query data and get a list of map
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');

    // return as a task object
    //generate a list
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
      );
    });
  }

  // fetch from table to-do in database

  Future<List<Todo>> getTodo(int taskId) async{
    Database _db = await database();

    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");

    return List.generate(todoMap.length, (index){
      return Todo(
        id: todoMap[index]['id'],
        taskId: todoMap[index]['taskId'],
        title: todoMap[index]['title'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }

  // update isDone to-do
  Future<void> updateTaskDone (int id, int isDone) async{
    Database _db = await database();

    await _db.rawUpdate("UPDATE todo SET isDone = $isDone WHERE id = $id ");
  }

  // delete to-do and tasks
  Future<void> deleteTask (int id) async{
    Database _db = await database();

    await _db.rawDelete("DELETE FROM tasks WHERE id = $id ");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = $id ");
  }
}
