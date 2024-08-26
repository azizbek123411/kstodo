import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kstodo/add_page.dart';
import 'package:kstodo/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List items = [];

  Future<void> getToDo() async {
    final response = await ApiService.getToDo();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error Occured',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteBy(String id) async {
//because we returned boolean type
    final success = await ApiService.deleteById(id);
    if (success) {
      getToDo();
    } else {}
  }

  Future<void> navigateToEditPage(Map item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddToDo(todo: item),
      ),
    );
    setState(() {
      isLoading = true;
    });
    getToDo();
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddToDo(),
            ),
          );
          setState(() {
            isLoading = true;
          });
          getToDo();
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: getToDo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Icon(
                Icons.free_breakfast_rounded,
                size: 90,
                color: Colors.grey,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return ListTile(
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          navigateToEditPage(item);
                        } else if (value == 'delete') {
                          deleteBy(id);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                      ],
                    ),
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
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
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
