import 'dart:ffi';

import 'package:complete_advanced_flutter/domain/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/store_details_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class StoreDetailsViewModelInputs {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outputStoreDetails;
}

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  final _storeDetailsStreamController = BehaviorSubject<StoreDetails>();
  StoreDetailsUseCase _storeDetailsUseCase;

  StoreDetailsViewModel(this._storeDetailsUseCase);

  /* LifeCycle Methods */
  @override
  void start() {
    _loadData();
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
  }

  /* Private Methods */
  _loadData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _storeDetailsUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
        StateRendererType.FULL_SCREEN_ERROR_STATE,
        failure.message,
      ));
    }, (storeDetails) {
      inputState.add(ContentState());
      inputStoreDetails.add(storeDetails);
    });
  }

  /* Inputs */
  @override
  Sink get inputStoreDetails => _storeDetailsStreamController.sink;

  /* Outputs */
  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _storeDetailsStreamController.stream.map((storeDetails) => storeDetails);
}
