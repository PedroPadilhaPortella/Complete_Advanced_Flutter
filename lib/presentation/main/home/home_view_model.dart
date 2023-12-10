import 'dart:async';
import 'dart:ffi';

import 'package:complete_advanced_flutter/domain/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;

  HomeViewObject(this.services, this.banners, this.stores);
}

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  HomeUseCase _homeUseCase;

  final _dataStreamController = BehaviorSubject<HomeViewObject>();

  HomeViewModel(this._homeUseCase);

  /* Lifecycle Methods */
  @override
  void start() {
    _getHome();
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  /* Public Methods */

  /* Inputs */
  @override
  Sink get inputHomeData => _dataStreamController.sink;

  /* Outputs */
  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);

  /* Private Methods */
  _getHome() async {
    inputState.add(LoadingState(
      stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE,
    ));

    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
        StateRendererType.FULL_SCREEN_ERROR_STATE,
        failure.message,
      ));
    }, (homeObject) {
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(
        homeObject.data.services,
        homeObject.data.banners,
        homeObject.data.stores,
      ));
    });
  }
}
