// test/main_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
import 'package:todo_material_you/main.dart';
import 'package:todo_material_you/model/task.dart';
import 'package:todo_material_you/repositories/task_repository.dart';
import 'package:todo_material_you/widgets/task.dart';

void main() {
  testWidgets('Adding task updates UI', (WidgetTester tester) async {
    final tasksBloc = TasksBloc(TaskRepository());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: tasksBloc,
            child: MyHomePage(title: 'Santa Application'),
          ),
        ),
      ),
    );

    final addButtonFinder = find.text('Add New Kid');
    await tester.tap(addButtonFinder);
    await tester.pumpAndSettle();

    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsOneWidget);

    final addDialogTextFields = find.byType(TextField);
    expect(addDialogTextFields, findsNWidgets(3));

    final addDialogAddButton = find.text('Add');
    expect(addDialogAddButton, findsOneWidget);

    // Enter task details in text fields
    await tester.enterText(addDialogTextFields.at(0), 'Test');
    await tester.enterText(addDialogTextFields.at(1), 'Test Country');
    await tester.enterText(addDialogTextFields.at(2), 'Test Status');

    // Tap on the 'Add' button
    await tester.tap(addDialogAddButton);
    await tester.pumpAndSettle();

    // Verify that the task is added and UI is updated
    final taskWidgetFinder = find.byType(TaskWidget);
    expect(taskWidgetFinder, findsOneWidget);

    // Clean up
    tasksBloc.close();
  });
}
