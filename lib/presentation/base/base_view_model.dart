import 'dart:async';

import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  // shared variables and functions that will be used through any view model.

  final StreamController _inputStateStreamController =
      BehaviorSubject<FlowState>();

  @override
  Sink get inputState => _inputStateStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStateStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStateStreamController.close();
  }
}

abstract class BaseViewModelInputs {
  void start();
  void dispose();

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
