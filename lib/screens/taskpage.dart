import 'package:flutter/material.dart';
import 'package:todo_task/database_helper.dart';
import 'package:todo_task/models/task.dart';
import 'package:todo_task/models/todo.dart';

import 'package:todo_task/widgets.dart';

class TaskPage extends StatefulWidget {

  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  String _taskTitle = "";
  String _taskDescription = "";
  int _taskId = 0;

  FocusNode _titleFocus, _todoFocus, _descriptionFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    // print("ID : ${widget.task.id}");

    // if is not new task
    if (widget.task != null) {

      // set visibility to true if is not new task
      _contentVisible = true;

      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
      _taskDescription = widget.task.description;
    }

    _titleFocus = FocusNode();
    _todoFocus = FocusNode();
    _descriptionFocus = FocusNode();

    super.initState();
  }

  // dispose focus node
  @override
  void dispose() {

    _titleFocus.dispose();
    _todoFocus.dispose();
    _descriptionFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // navigate back to home page
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image.asset(
                                "assets/images/back_arrow_icon.png"),
                          ),
                        ),

                        // TextField for task title
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              // insert value to database
                              if (value.trim() != "") {
                                // check if task received from homepage is null
                                if (widget.task == null) {

                                  // if null create new task
                                  Task _newTask = Task(title: value);

                                  // insert into database and get taskId
                                  _taskId = await _dbHelper.insertTask(_newTask);

                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                  print("new task id: $_taskId");
                                } else {
                                  // update existing task
                                  await _dbHelper.updateTaskTitle(value, _taskId);

                                  print("Update the existing task $_taskId");

                                }
                              } // end of if statement for .trim()

                              //change focus to description textField
                              _descriptionFocus.requestFocus();
                            }, // end of onSubmitted

                            // set TextField value to title from homePage
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Task Title",
                            ),

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                              fontSize: 26.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TextField Widget for task Description
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if(value.trim().isNotEmpty){

                            //if _taskId is not 0 i.e. if is not a new task
                            if(_taskId != 0){
                              // update task description to database
                              await _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDescription = value;

                              print("Description updated");
                            }

                          }

                          // change cursor focus to to-do tetField
                          _todoFocus.requestFocus();
                        },  // OnSubmitted
                        controller: TextEditingController()..text = _taskDescription,
                        decoration: InputDecoration(
                            hintText: "Enter Description for task",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24.0)),
                      ),
                    ),
                  ),

                  // list to-do tasks
                  Visibility(
                      visible: _contentVisible,
                      child: FutureBuilder(
                          initialData: [],
                          // get to-do items from database
                          future: _dbHelper.getTodo(_taskId),
                          builder: (context, snapshot) {
                            return Expanded(
                              child: ScrollConfiguration(
                                behavior: NoGlowEffect(),

                                child: ListView.builder(

                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async{
                                          // switch the to-do completion state
                                          if(snapshot.data[index].isDone == 0){
                                            await _dbHelper.updateTaskDone(snapshot.data[index].id, 1);
                                          }else{
                                            await _dbHelper.updateTaskDone(snapshot.data[index].id, 0);
                                          }
                                          setState(() {

                                          });
                                        },
                                        child: TodoWidget(
                                          text: snapshot.data[index].title,
                                            isDone: snapshot.data[index].isDone == 0 ? false : true,  // snapshot first returns integer
                                        ),
                                      );
                                    }),
                              ),
                            );
                          }),
                    ),

                  // input text field
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: 12.0,
                            ),
                            width: 23.0,
                            height: 23.0,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Color(0xFF86829D),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Image.asset("assets/images/check_icon.png"),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if (value.trim() != "") {
                                  // create new to-do for tasks
                                  if (_taskId != 0) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();

                                    Todo _newTodo = Todo(
                                        title: value,
                                        isDone: 0,
                                        taskId: _taskId);

                                    // insert into database
                                    await _dbHelper.insertTodo(_newTodo);
                                    print("Creating new todo");
                                    // set the state i.e reload
                                    setState(() {
                                      // set focus node
                                      _todoFocus.requestFocus();
                                    });

                                    //clear
                                  } else {
                                    print("Empty Todo");
                                  }
                                } // end of if statement for .trim()
                              },

                              controller: TextEditingController(
                                text: "",
                              ),
                              decoration: InputDecoration(
                                  hintText: "Enter Todo item...",
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if(_taskId != 0){
                        // delete task and to-do items
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image.asset("assets/images/delete_icon.png"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
