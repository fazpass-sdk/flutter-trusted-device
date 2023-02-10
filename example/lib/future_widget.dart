
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FutureWidget<T> extends StatefulWidget {
  final String functionName;
  final Future<T> Function() future;
  final String Function(T) successMessage;
  final String? importantNote;

  const FutureWidget({
    super.key, 
    required this.future, 
    required this.successMessage, 
    required this.functionName, 
    this.importantNote});

  @override
  State<FutureWidget<T>> createState() => _FutureWidgetState<T>();
}

class _FutureWidgetState<T> extends State<FutureWidget<T>> {
  int keyValue = 0;
  Future<T>? future;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: FutureBuilder(
      key: ValueKey(keyValue),
      future: future,
      builder: (context, snapshot) {
        PlatformException? exception;
        Object? unknownException;
        if (snapshot.hasError) {
          if (snapshot.error is PlatformException) {
            exception = snapshot.error as PlatformException;
          } else {
            unknownException = snapshot.error;
          }
        }

        return Column(
          children: [
            ElevatedButton(
              onPressed: snapshot.connectionState==ConnectionState.waiting
                  ? null
                  : () => setState(() {
                future = widget.future();
                keyValue++;
              }),
              child: Text(widget.functionName),
            ),
            if (exception != null) Text('ERR CODE: ${exception.code} | ERR MESSAGE: ${exception.message}\n'
                'ERR DETAILS: ${exception.details}\n'
                'STACKTRACE: ${exception.stacktrace}'),
            if (unknownException != null) Text(unknownException.toString()),
            if (snapshot.hasData) Text(widget.successMessage(snapshot.data as T)),
            if (widget.importantNote != null) Text(
              widget.importantNote!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    ),
  );
}
