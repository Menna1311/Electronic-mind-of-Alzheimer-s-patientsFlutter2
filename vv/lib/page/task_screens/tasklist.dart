import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:vv/page/task_screens/adddtask.dart';
import 'package:vv/page/task_screens/details.dart';
import 'package:vv/widgets/backbutton.dart';
import 'package:vv/widgets/task_widgets/dayselect.dart';
import 'package:vv/widgets/task_widgets/yearmonth.dart';

import '../../models/task.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  Task? selectedTask;
  Color pickedColor = Color(0xFF0386D0);
  void updateTask(Task oldTask, Task newTask) {
    setState(() {
      final index = tasks.indexOf(oldTask);
      tasks[index] = newTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.bottomCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFFFFFF), Color(0xff3B5998)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(39.0),
                bottomRight: Radius.circular(39.0),
              ),
              color: Color.fromRGBO(255, 255, 255, 0.708),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(39.0),
                  bottomRight: Radius.circular(39.0),
                ),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Medicines',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      BackButtonWidget(),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(width: 40),
                          CurrentMonthYearWidget(),
                          SizedBox(width: 40),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    onTaskAdded: addTask,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 30,
                              ),
                              elevation: 4,
                              backgroundColor: pickedColor,
                            ),
                            child: Text('+Add Medicine'),
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DaySelector(),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Medicines',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'lib/page/task_screens/assets/icon_small.png',
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        tasks[index].name,
                        style: TextStyle(
                          decoration: tasks[index].completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        '${DateTime.now().day}. ${DateFormat('MMM').format(DateTime.now())}. ${DateTime.now().year}',
                      ),
                      trailing: Checkbox(
                        value: tasks[index].completed,
                        onChanged: (value) {
                          setState(() {
                            tasks[index].completed = value!;
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsScreen(
                              task: tasks[index],
                              onTaskUpdated: (editedTask) {
                                updateTask(tasks[index], editedTask);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }
}

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    );
  }
}

class CurrentMonthYearWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '${DateFormat('MMMM').format(DateTime.now())} ${DateTime.now().year}',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}



