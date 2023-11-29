// tasks_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
import 'package:todo_material_you/model/task.dart';
import 'package:todo_material_you/repositories/task_repository.dart';

void main() {
  group('TasksBloc Tests', () {
    late TasksBloc tasksBloc;

    setUp(() {
      tasksBloc = TasksBloc(TaskRepository());
    });

    test('Loading tasks', () async {
      expectLater(
        tasksBloc.stream,
        emitsInOrder([TasksLoading(), isA<TasksLoaded>()]),
      );

      tasksBloc.add(LoadTask());
    });

    test('Adding a task', () async {
      final task = Task(id: 1, name: 'Test', country: 'Test Country', status: 'Test Status');

      expectLater(
        tasksBloc.stream,
        emitsInOrder([isA<TasksLoaded>(), TasksLoaded(tasks: [task])]),
      );

      tasksBloc.add(AddTask(task: task));
    });


    test('Updating a task', () async {
      final task = Task(id: 1, name: 'Test', country: 'Test Country', status: 'Test Status');
      final updatedTask = Task(id: 1, name: 'Updated Test', country: 'Updated Test Country', status: 'Updated Test Status');

      tasksBloc.add(AddTask(task: task));

      expectLater(
        tasksBloc.stream,
        emitsInOrder([isA<TasksLoaded>(), TasksLoaded(tasks: [updatedTask])]),
      );

      tasksBloc.add(UpdateTask(task: updatedTask));
    });

    tearDown(() {
      tasksBloc.close();
    });
  });
}
