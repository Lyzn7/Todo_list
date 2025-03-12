import 'package:flutter/material.dart';
import 'package:todo_list/models/Taskmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? Key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Taskmodel> tasksList = [];
  final TextEditingController tasktextedtingcontrol = TextEditingController();
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    readTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('ini lah To Do List'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            )),
        child: tasksList.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: ListView.builder(
                        itemCount: tasksList.length,
                        itemBuilder: (context, index) {
                          final Taskmodel task = tasksList[index];
                          return ListTile(
                            title: Text(
                              task.tittle,
                              style: TextStyle(
                                color: task.isCompleted
                                    ? Colors.grey
                                    : Colors.black,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 20,
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  deletetask(taskId: task.id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                  size: 20,
                                )),
                            leading: Transform.scale(
                              scale: 2.0,
                              child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  value: task.isCompleted,
                                  onChanged: (isChecked) {
                                    final Taskmodel updatetedTask = task;
                                    updatetedTask.isCompleted = isChecked!;
                                    updateTask(
                                        taskId: updatetedTask.id,
                                        updatedTask: updatetedTask);
                                  }),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'tidak ada data',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('New Task'),
                    content: TextField(
                      controller: tasktextedtingcontrol,
                      decoration:
                          const InputDecoration(hintText: 'Enter new task'),
                      maxLines: 2,
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('cancel')),
                      TextButton(
                          onPressed: () {
                            if (tasktextedtingcontrol.text.isNotEmpty) {
                              final Taskmodel newTask = Taskmodel(
                                  id: DateTime.now().toString(),
                                  tittle: tasktextedtingcontrol.text);
                              createtask(task: newTask);
                              tasktextedtingcontrol.clear();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save')),
                    ],
                  );
                });
          }),
    );
  }

  void createtask({required Taskmodel task}) {
    setState(() {
      tasksList.add(task);
      saveOnLocal();
    });
  }

  void deletetask({required String taskId}) {
    setState(() {
      tasksList.removeWhere((task) => task.id == taskId);
      saveOnLocal();
    });
  }

  void updateTask({required String taskId, required Taskmodel updatedTask}) {
    final taskIndex = tasksList.indexWhere((task) => task.id == taskId);
    setState(() {
      tasksList[taskIndex] = updatedTask;
      saveOnLocal();
    });
  }

  void saveOnLocal() {
    final taskData = tasksList.map((task) => task.toJson()).toList();
    sharedPreferences?.setStringList('task', taskData);
  }

  void readTask() {
    setState(() {
      final taskData = sharedPreferences?.getStringList('task') ?? [];
      tasksList =
          taskData.map((taskJson) => Taskmodel.fromJson(taskJson)).toList();
    });
  }
}
