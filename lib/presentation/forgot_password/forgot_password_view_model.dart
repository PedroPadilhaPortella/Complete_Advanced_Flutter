import 'dart:async';

import 'package:complete_advanced_flutter/app/functions.dart';
import 'package:complete_advanced_flutter/domain/usecase/forgot_password_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';

abstract class ForgotPasswordViewModelInputs {
  setEmail(String email);
  forgotPassword();

  Sink get inputEmail;
  Sink get inputIsAllInputsValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsAllInputsValid;
}

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  var email = "";

  ForgotPasswordUseCase _forgotPasswordUseCase;

  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  /* Lifecycle Methods */
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputsValidStreamController.close();
  }

  /* Public Methods */
  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  forgotPassword() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE),
    );
    (await _forgotPasswordUseCase.execute(email)).fold(
      (failure) {
        inputState.add(
          ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message),
        );
      },
      (data) {
        inputState.add(ContentState());
      },
    );
  }

  /* Inputs */
  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputsValid => _isAllInputsValidStreamController.sink;

  /* Outputs */
  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((userName) => isEmailValid(userName));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());

  /* Private Methods */
  _validate() {
    inputIsAllInputsValid.add(null);
  }

  bool _isAllInputsValid() {
    return isEmailValid(email);
  }
}
