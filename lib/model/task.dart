class Task {

  int id;
  String taskName;
  bool complete;

  Task({this.id,this.taskName, this.complete});

  Map<String, dynamic> toMap() {

    Map<String,dynamic> map = {

      "taskName": this.taskName,
      "isComplete": (this.complete).toString(),

    };


    return map;
  }

}


