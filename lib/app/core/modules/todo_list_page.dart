import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class TodoListPage extends StatelessWidget {
  final List<SingleChildWidget>? _bindings;
  final WidgetBuilder _page;

  const TodoListPage({
    List<SingleChildWidget>? binding,
    required WidgetBuilder page,
    Key? key,
  })  : _bindings = binding,
        _page = page,
        super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _bindings ??
          [
            Provider(
              create: (_) => Object(),
            ),
          ],
      child: Builder(
        builder: (context) => _page(context),
      ),
    );
  }
}
