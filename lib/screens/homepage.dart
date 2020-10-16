import 'package:flutter/material.dart';
import 'package:todo_task/database_helper.dart';
import 'package:todo_task/screens/taskpage.dart';
import 'package:todo_task/widgets.dart';
import 'package:todo_task/models/task.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  void insertInfo() async{
    String value = "Welcome to Todo-Task!";
    String description = "Create a new task by clicking on the add button";

    Task _newTask = Task(title: value, description: description);

    // insert into database and get taskId
    await _dbHelper.insertTask(_newTask);
  }


  @override
  void initState() {
    insertInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF1F1F1),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 32.0, top: 32.0),
                      child:
                          Image(image: AssetImage("assets/images/logo.png"))),
                  Expanded(
                    child: FutureBuilder(
                        initialData: [],
                        future: _dbHelper.getTasks(),
                        builder: (context, snapshot) {
                          return ScrollConfiguration(
                            behavior: NoGlowEffect(),
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // navigate to task page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            // print(snapshot.data[index].title);
                                            return TaskPage(
                                              task: snapshot.data[index],
                                            );
                                          },
                                        ),
                                      ).then(   // end of navigator.push
                                        (value) {
                                          // reset state when navigate back to homepage because task title may have been updated
                                          setState(() {});
                                        },
                                      );
                                    },
                                    child: TaskCardWidget(
                                      title: snapshot.data[index].title,
                                      desc: snapshot.data[index].description,
                                    ),
                                  );
                                },
                            ),
                          );
                        }),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    // navigate to TaskPage
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskPage(
                                  task: null,
                                ))).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                        begin: Alignment(0.0, -1.0), // top to bottom
                        end: Alignment(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image.asset("assets/images/add_icon.png"),
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
