import 'package:clean_architecture_app/composers/todo_bloc_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Clean architecture todo list"),
        ),
        body: BlocProvider(
            create: (_) => todoBlocComposer(),
            child: Column(
              children: <Widget>[],
            )),
      );
}
