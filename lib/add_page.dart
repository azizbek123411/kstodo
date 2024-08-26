import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDo extends StatefulWidget {
  final Map? todo;

  const AddToDo({
    super.key,
    this.todo,
  });

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  Future<void> addToDo() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            'Succesfully Added',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error Occurred',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  Future<void> updateToDo() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo["_id"];
    final isCompleted = todo["is_completed"];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode==200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            'Updation Added',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error Occurred',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

  }

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          isEdit ? "Edit To Do" : 'Add To Do',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            maxLines: 8,
            minLines: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateToDo : addToDo,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(
              isEdit ? "Update" : 'Create',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
