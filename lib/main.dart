import 'package:flutter/material.dart';

import 'database/database.dart';
import 'model/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String task;
  List<Task> taskList = [];



  @override
  void initState() {

    getTaskList();

    super.initState();
  }

  void getTaskList()async {

    List<Map<String, String>> _result = await DB.query("Task");

try{
  print(_result.length);
}

catch(e){
  print(e.toString());
}


  }

  List<Widget> getTasksWidget() {
    List<Widget> myContainer = [];
    for (int i = 0; i < taskList.length; i++) {
      myContainer.add(Container(
        child: Row(
          children: <Widget>[
            Text(taskList[i].taskName),
            taskList[i].complete
                ? Icon(Icons.radio_button_checked)
                : Icon(Icons.radio_button_unchecked),
          ],
        ),
      ));
    }

    return myContainer;
  }

  addTask (Task task)async{
  var value  = await  DB.insert(task);
  print(value);

    getTaskList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sql practise'),
        actions: <Widget>[IconButton(
          icon: Icon(Icons.add),
          onPressed: (){

             showModalBottomSheet<void>(
context: context,
            builder: (BuildContext context) {


              String taskName;
              bool isComplete = false;

              return Column(
                children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Task Name',

                          ),
                      onChanged: (value){
                     taskName = value;
                             },


                        ),


                    Switch(
                      value:isComplete,
                      onChanged: (value){
                        setState(() {
                          isComplete = value;
                        });
                      },
                    ),


                  RaisedButton(

                    child: Text('Save'),
                    onPressed: (){
                      Task task = Task(taskName:taskName, complete: false );
                      addTask(task);
                    },

                  ),


                ],

              );

            }
            );

          },
        )],
      ),
      body: Column(
        children: getTasksWidget(),
      ),
    );
  }
}
