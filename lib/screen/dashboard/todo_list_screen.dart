import 'package:flutter/material.dart';
import 'package:hwpldemo/screen/dashboard/logic/logic.dart';
import 'package:provider/provider.dart';

import 'model/todo_entity.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial todos if list is empty
    Future.microtask(() {
      final provider = Provider.of<TodoProvider>(context, listen: false);
      if (provider.posts.isEmpty) {
        provider.fetchPosts();
      }
    });

    // Fetch next page on scroll to bottom
    _scrollController.addListener(() {
      final provider = Provider.of<TodoProvider>(context, listen: false);
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !provider.isLoading) {
        provider.fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(' Todos'),
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, postProvider, child) {
          // Show error message if fetch failed
          if (postProvider.errorMessage != null) {
            return Center(
              child: Text(
                postProvider.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final posts = postProvider.posts;

          return ListView.builder(
            controller: _scrollController,
            itemCount: posts.length + (postProvider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final post = posts[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "${post.title[0].toUpperCase()}${post.title.substring(1)}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('ID: ${post.id}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: post.completed,
                        onChanged: (_) => postProvider.toggleCompleted(post),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => postProvider.deleteTodo(post),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController _controller = TextEditingController();

              return AlertDialog(
                title: Text('Add Todo'),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Enter todo title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final title = _controller.text.trim();
                      if (title.isNotEmpty) {
                        final id = DateTime.now().millisecondsSinceEpoch;
                        final newTodo = TodoEntity(
                          id: id,
                          title: title,
                          completed: false,
                          isLocal: true,
                          userId: 0,
                        );
                        Provider.of<TodoProvider>(
                          context,
                          listen: false,
                        ).addTodo(newTodo);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
