import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kstodo/add_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];

  Future<void> getToDo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=11';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddToDo(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh:getToDo,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              return ListTile(
                title: Text(
                  item['title'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  item['description'],
                ),
                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'To Do list',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
