
import 'package:flutter/material.dart';

class ListenableWidget extends StatefulWidget {
  final String functionName;
  final Function() function;
  final ValueNotifier<String?> notifier;

  const ListenableWidget({super.key, required this.functionName, required this.notifier, required this.function});

  @override
  State<ListenableWidget> createState() => _ListenableWidgetState();
}

class _ListenableWidgetState extends State<ListenableWidget> {

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: ValueListenableBuilder(
      valueListenable: widget.notifier,
      builder: (context, value, child) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: value == ''
                  ? null
                  : widget.function,
              child: Text(widget.functionName),
            ),
            Text(value ?? ''),
          ],
        );
      },
    ),
  );
}
