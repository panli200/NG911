import 'package:bloc/bloc.dart';
import 'dart:async';

class MessagesBloc{
  final stateStreamController = StreamController<String>();

  StreamSink<String> get messageSink => stateStreamController.sink;
  Stream<String> get messageStream => stateStreamController.stream;
}