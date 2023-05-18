class toDo {
  String? id;
  String? toDoText;
  bool isDone;

  toDo({
    required this.id,
    required this.toDoText,
    this.isDone = false,
  });

  static List<toDo> toDoList() {
    return [
      toDo(id: '01', toDoText: 'texto prueba', isDone: true),
      toDo(id: '02', toDoText: 'texto prueba', isDone: true),
      toDo(id: '03', toDoText: 'texto prueba', isDone: true),
      toDo(id: '04', toDoText: 'texto prueba'),
      toDo(id: '05', toDoText: 'texto prueba'),
      toDo(id: '06', toDoText: 'texto prueba'),
    ];
  }
}
