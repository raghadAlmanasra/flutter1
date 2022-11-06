import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_lsit/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Task> tasks = [];
  List<Task> completedTasks = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 156, 168, 173),
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Inbox"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.white,
                  width: width,
                  height: height / 3,
                  child: Expanded(
                    child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              leading: IconButton(
                                icon: Icon(Icons.check_box_outline_blank),
                                onPressed: () {
                                  completedTasks.add(tasks[index]);
                                  tasks.removeAt(index);
                                  setState(() {});
                                },
                              ),
                              trailing: Text(
                                tasks[index].taskDate!,
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 15),
                              ),
                              title: Text(tasks[index].taskName!));
                        }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.white,
                  width: width,
                  height: height / 3,
                  child: Column(
                    children: [
                      const Text(
                        "Completed",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: completedTasks.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ListTile(
                                    leading: IconButton(
                                        icon: Icon(Icons.check_box),
                                        onPressed: () {
                                          tasks.add(completedTasks[index]);
                                          completedTasks.removeAt(index);
                                          setState(() {});
                                        },
                                        color: const Color.fromARGB(
                                            255, 156, 168, 173)),
                                    trailing: Text(
                                      completedTasks[index].taskDate!,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 156, 168, 173)),
                                    ),
                                    title: Text(
                                      completedTasks[index].taskName!,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 156, 168, 173)),
                                    ))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_incrementCounter;
          OpenDialog();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future OpenDialog() => showDialog(
      context: context,
      builder: (context) {
        String? taskName;
        String? taskDate;
        return StatefulBuilder(builder: (context, setState) {
          if (taskDate == null) {
            taskDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          }
          return AlertDialog(
            title: Text("Add new task"),
            content: Container(
              width: 250,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Task Name"),
                  Container(
                      width: 250,
                      child: TextField(
                        onChanged: (value) => taskName = value,
                        decoration: InputDecoration(hintText: "task name"),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Task date"),
                  Row(
                    children: [
                      Container(width: 200, child: Text(taskDate!)),
                      IconButton(
                        onPressed: (() async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));

                          setState(() {
                            taskDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate!);
                            print(taskDate);
                          });
                        }),
                        icon: Icon(Icons.date_range),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (() {
                    if (taskName == "" || taskName == null) {
                      taskName = "Unnamed Task ";
                      print(taskName);
                    }

                    tasks.add(Task(taskName: taskName, taskDate: taskDate));
                    Navigator.of(context).pop();
                    setState(() {});
                  }),
                  child: Text("Add text"))
            ],
          );
        });
      });
}
