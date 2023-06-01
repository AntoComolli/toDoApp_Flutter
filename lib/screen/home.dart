import 'package:flutter/material.dart';
import 'package:toaflutter_/constants/colors.dart';
import 'package:toaflutter_/mode/todo.dart';
import 'package:toaflutter_/widget/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final toDoList = toDo.toDoList();
  List<toDo> foundToDo = [];
  final toDoController = TextEditingController();

  @override
  void initState() {
    _loadToDoList();
    super.initState();
  }

  void _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final todoListString = prefs.getStringList('todoList') ?? [];

    setState(() {
      toDoList.clear();
      for (final todoText in todoListString) {
        toDoList.add(toDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          toDoText: todoText,
        ));
      }
      foundToDo = toDoList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _builtAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(children: [
              searchBox(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 50,
                        bottom: 20,
                      ),
                      child: const Text(
                        'Todas las tareas',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    for (toDo todo in foundToDo.reversed)
                      toDoItem(
                        todo: todo,
                        onTodoChanged: _handleToDoChanged,
                        onDeleteItem: _deleteToDoItem,
                      ),
                  ],
                ),
              )
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: toDoController,
                    autocorrect: true,
                    decoration: InputDecoration(
                        hintText: 'Agregar nueva tarea',
                        border: InputBorder.none),
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 40),
                    ),
                    onPressed: () {
                      _addToDoItem(toDoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChanged(toDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      toDoList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String todo) async {
    final prefs = await SharedPreferences.getInstance();
    final todoListString = prefs.getStringList('todoList') ?? [];

    setState(() {
      toDoList.add(toDo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        toDoText: todo,
      ));
    });

    todoListString.add(todo);
    prefs.setStringList('todoList', todoListString);

    toDoController.clear();
  }

  void _runFilter(String enteredKeywords) {
    List<toDo> result = [];
    if (enteredKeywords.isEmpty) {
      result = toDoList;
    } else {
      result = toDoList
          .where((item) => item.toDoText!
              .toLowerCase()
              .contains(enteredKeywords.toLowerCase()))
          .toList();
    }
    setState(() {
      foundToDo = result;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _builtAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/fotoanto.png'),
          ),
        )
      ]),
    );
  }
}
