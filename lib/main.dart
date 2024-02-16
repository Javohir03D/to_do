import 'package:flutter/material.dart';
import 'package:to_do/reapasitory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Repository repository;

  @override
  void initState() {
    super.initState();
    repository = Repository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _addDialog(),
        child: Icon(Icons.add_box),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<ToDoModel>>(
        stream: repository.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("not todo"));
          }
          final todos = snapshot.data!;
          return ListView.separated(
            itemBuilder: (_, index) => ListTile(
              title: Text(todos[index].title),
              subtitle: Text(todos[index].description),
            ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: todos.length,
          );
        },
      ),
    );
  }

  void _addDialog() {
    String title = '';
    String description = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Colors.red,
                onChanged: (value) => title = value,
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
              ),
              TextField(
                cursorColor: Colors.red,
                onChanged: (value) => description = value,
                decoration: const InputDecoration(hintText: "Title"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Icon(Icons.save_as),
              onPressed: () async {
                if (title.isNotEmpty && description.isNotEmpty) {
                  await repository.createToDo(title, description);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
