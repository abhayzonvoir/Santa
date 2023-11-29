import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
import 'package:todo_material_you/model/task.dart';
import 'package:todo_material_you/repositories/task_repository.dart';
import 'package:todo_material_you/widgets/task.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App for Santa - Development Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color(0XFFceef86),
          backgroundColor: const Color(0XFF201a1a)),
      home: RepositoryProvider(
        create: (context) => TaskRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => TasksBloc(
                      RepositoryProvider.of<TaskRepository>(context),
                    )..add(const LoadTask()))
          ],
          child: const MyHomePage(title: 'Santa Application'),
        ),
      ),
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
  late TextEditingController textInputNamesController;
  late TextEditingController textInputCountriesController;
  late TextEditingController textInputStatusController;

  @override
  void initState() {
    super.initState();

    textInputNamesController = TextEditingController();
    textInputCountriesController = TextEditingController();
    textInputStatusController = TextEditingController();
  }

  @override
  void dispose() {
    textInputNamesController.dispose();
    textInputCountriesController.dispose();
    textInputStatusController.dispose();
    super.dispose();
  }

  Future<Task?> _openDialog(int lastId) {
    textInputNamesController.text = '';
    textInputCountriesController.text = '';
    textInputStatusController.text = '';

    return showDialog<Task>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.lightBlue,
              title: const Text("Enter children details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: TextField(
                          controller: textInputNamesController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Child name',
                              border: InputBorder.none,
                              filled: false)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: TextField(
                          controller: textInputCountriesController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Child countries',
                              border: InputBorder.none,
                              filled: false)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: TextField(
                          controller: textInputStatusController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: 'Child status',
                              border: InputBorder.none,
                              filled: false)),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: (() {
                      if (textInputNamesController.text != '' &&
                          textInputCountriesController.text != '' &&
                          textInputStatusController.text != '') {
                        Navigator.of(context).pop(Task(
                            id: lastId + 1,
                            name: textInputNamesController.text,
                            country: textInputCountriesController.text,
                            status: textInputStatusController.text));
                      }
                    }),
                    child: const Text('Add',
                        style: TextStyle(color: Colors.white)))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    int? lastId;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const CircularProgressIndicator();
          }
          if (state is TasksLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ...state.tasks.map(
                      (task) => InkWell(
                        onTap: (() {
                          context.read<TasksBloc>().add(UpdateTask(
                              task:
                                  task.copyWith(isComplete: !task.isComplete)));
                        }),
                        child: TaskWidget(
                          task: task,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Text('No Record  Found');
          }
        },
      ),
      floatingActionButton: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksLoaded) {
            lastId = state.tasks.last.id;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Record Updated!'),
            ));
          }
        },
        child:ElevatedButton(
          onPressed: () async {
            // Open the dialog to get the task details
            Task? task = await _openDialog(lastId ?? 0);

            // Check if a task was returned
            if (task != null) {
              // Add the task using the TasksBloc
              context.read<TasksBloc>().add(
                AddTask(task: task),
              );
            }
          },
          child: const Text(
            "Add New Kid",
            style: TextStyle(color: Colors.blue),
          ),
        )

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
