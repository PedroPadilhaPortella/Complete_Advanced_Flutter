import 'dart:async';
import 'dart:ffi';

import 'package:complete_advanced_flutter/domain/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class HomeViewModelInputs {
  // Sink get inputServices;
  // Sink get inputBanners;
  // Sink get inputStores;
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  // Stream<List<Service>> get outputServices;
  // Stream<List<BannerAd>> get outputBanners;
  // Stream<List<Store>> get outputStores;
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

  // StreamController _bannersStreamController = BehaviorSubject<List<BannerAd>>();
  // StreamController _servicesStreamController = BehaviorSubject<List<Service>>();
  // StreamController _storesStreamController = BehaviorSubject<List<Store>>();
  final _dataStreamController = BehaviorSubject<HomeViewObject>();

  HomeViewModel(this._homeUseCase);

  /* Lifecycle Methods */
  @override
  void start() {
    _getHome();
  }

  @override
  void dispose() {
    // _bannersStreamController.close();
    // _servicesStreamController.close();
    // _storesStreamController.close();
    _dataStreamController.close();
    super.dispose();
  }

  /* Public Methods */

  /* Inputs */
  // @override
  // Sink get inputServices => _servicesStreamController.sink;

  // @override
  // Sink get inputBanners => _bannersStreamController.sink;

  // @override
  // Sink get inputStores => _storesStreamController.sink;

  @override
  Sink get inputHomeData => _dataStreamController.sink;

  /* Outputs */
  // @override
  // Stream<List<Service>> get outputServices =>
  //     _servicesStreamController.stream.map((services) => services);

  // @override
  // Stream<List<BannerAd>> get outputBanners =>
  //     _bannersStreamController.stream.map((banners) => banners);

  // @override
  // Stream<List<Store>> get outputStores =>
  //     _storesStreamController.stream.map((stores) => stores);

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
      // inputBanners.add(homeObject.data.banners);
      // inputServices.add(homeObject.data.services);
      // inputStores.add(homeObject.data.stores);
      inputHomeData.add(HomeViewObject(
        homeObject.data.services,
        homeObject.data.banners,
        homeObject.data.stores,
      ));
    });
  }
}
