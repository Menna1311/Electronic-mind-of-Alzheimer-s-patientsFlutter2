import 'dart:async';

import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vv/Patient/mainpagepatient/mainpatient.dart';
import 'package:vv/daily_task/common/database/task_database.dart';
import 'package:vv/daily_task/common/entities/task.dart';
import 'package:vv/daily_task/common/values/constant.dart';
import 'package:vv/daily_task/pages/home/bloc/home_bloc.dart';
import 'package:vv/daily_task/pages/home/bloc/home_state.dart';
import 'package:vv/daily_task/pages/input/input_controller.dart';
import 'package:vv/daily_task/pages/input/input_page.dart';
import 'home_widgets.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:vv/utils/token_manage.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  List<Task> nonRepeatingTasks = [];
  List<Task> repeatingTasks = [];
  List<List<Task>> tasksList = [];
  List<Task> selectedTask = [];
  bool isLoading = false;

  Future<void> refreshTasks() async {
    setState(() => isLoading = true);
    tasks = await TasksDatabase.instance.readAllTasks();
    nonRepeatingTasks.clear();
    repeatingTasks.clear();
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].recurrence == AppConstant.INITIAL_RECURRENCE) {
        nonRepeatingTasks.add(tasks[i]);
      } else {
        repeatingTasks.add(tasks[i]);
      }
    }
    nonRepeatingTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    tasksList = [nonRepeatingTasks, repeatingTasks];

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    refreshTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3B5998),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const mainpatient()),
            );
          },
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 0.0,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 128, 171, 236),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Aligning "Tasks" to the left
            Text(
              'Tasks'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
            // Aligning the other widget to the right (if any)
            const SizedBox(width: 56.0), // Adjust the width as per your need
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffFFFFFF), Color(0xff3B5998)],
          ),
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                    ? Center(
                        child: Text(
                          'No Tasks'.tr(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 47, 47, 47),
                              fontSize: 24),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasksList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              index == 0
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 20,
                                      ),
                                      child: nonRepeatingTasks.isEmpty
                                          ? const SizedBox(
                                              width: 0,
                                              height: 0,
                                            )
                                          : Text('My Tasks'.tr()),
                                    )
                                  : Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 30,
                                      ),
                                      child: repeatingTasks.isEmpty
                                          ? const SizedBox(
                                              width: 0,
                                              height: 0,
                                            )
                                          : Text(
                                              "REPEATED".tr(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: tasksList[index].length,
                                itemBuilder: (BuildContext context, int i) {
                                  return buildTask(
                                    task: tasksList[index][i],
                                    done: selectedTask
                                        .contains(tasksList[index][i]),
                                    onChanged: (curValue) {
                                      if (selectedTask
                                          .contains(tasksList[index][i])) {
                                        selectedTask
                                            .remove(tasksList[index][i]);
                                      } else {
                                        selectedTask.add(tasksList[index][i]);
                                      }
                                      InputController(context: context)
                                          .cancelNotification(
                                              tasksList[index][i].id);
                                      TasksDatabase.instance
                                          .delete(tasksList[index][i].id);
                                      refreshTasks(); // Refresh tasks after deletion
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Task completed".tr(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
          },
        ),
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 0.0,
        openElevation: 4.0,
        transitionDuration: const Duration(milliseconds: 1500),
        openBuilder: (BuildContext context, VoidCallback _) =>
            const InputPage(),
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        closedColor: const Color.fromARGB(255, 128, 171, 236),
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return SizedBox(
            width: 56.0,
            height: 56.0,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}
