import 'dart:async';

import 'package:easy_localization/easy_localization.dart';

import '../../domain/model.dart';
import '../base/base_view_model.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';

abstract class OnboardingViewModelInputs {
  void goNext();
  void goPrevious();
  void onPageChanged(int index);

  Sink get inputSliderViewObject;
}

abstract class OnbooardingViewModelOutputs {
  Stream<SlideViewObject> get outputSliderViewObject;
}

class SlideViewObject {
  SliderObject sliderObject;
  int numOfSlides;
  int currentIndex;

  SlideViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}

class OnboardingViewModel extends BaseViewModel
    with OnboardingViewModelInputs, OnbooardingViewModelOutputs {
  final StreamController _streamController =
      StreamController<SlideViewObject>();

  late final List<SliderObject> _list;
  int _currentIndex = 0;

  @override
  void start() {
    _list = _getSliderData();
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  int goNext() {
    int nextIndex = _currentIndex++;
    if (nextIndex >= _list.length) {
      _currentIndex = 0;
    }
    return _currentIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentIndex--; // -1
    if (previousIndex == -1) {
      _currentIndex = _list.length - 1;
    }
    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  @override
  Stream<SlideViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  List<SliderObject> _getSliderData() => [
        SliderObject(
          AppStrings.onBoardingTitle1.tr(),
          AppStrings.onBoardingSubTitle1.tr(),
          ImageAssets.onboardingLogo1,
        ),
        SliderObject(
          AppStrings.onBoardingTitle2.tr(),
          AppStrings.onBoardingSubTitle2.tr(),
          ImageAssets.onboardingLogo2,
        ),
        SliderObject(
          AppStrings.onBoardingTitle3.tr(),
          AppStrings.onBoardingSubTitle3.tr(),
          ImageAssets.onboardingLogo3,
        ),
        SliderObject(
          AppStrings.onBoardingTitle4.tr(),
          AppStrings.onBoardingSubTitle4.tr(),
          ImageAssets.onboardingLogo4,
        ),
      ];

  _postDataToView() {
    inputSliderViewObject.add(
        SlideViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
}
