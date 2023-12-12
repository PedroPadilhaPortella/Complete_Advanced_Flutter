import 'dart:io';

import 'package:complete_advanced_flutter/app/app_preferences.dart';
import 'package:complete_advanced_flutter/app/dependency_injection.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/presentation/common/state_render/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/register/register_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  ImagePicker picker = instance<ImagePicker>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameEditingController =
      TextEditingController();

  final TextEditingController _mobileNumberEditingController =
      TextEditingController();

  final TextEditingController _emailEditingController = TextEditingController();

  final TextEditingController _passwordEditingController =
      TextEditingController();

  /* LifeCycle Methods */
  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  /* Private Methods */
  _bind() {
    _viewModel.start();

    _userNameEditingController.addListener(() {
      _viewModel.setUserName(_userNameEditingController.text);
    });

    _passwordEditingController.addListener(() {
      _viewModel.setPassword(_passwordEditingController.text);
    });

    _emailEditingController.addListener(() {
      _viewModel.setEmail(_emailEditingController.text);
    });

    _mobileNumberEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberEditingController.text);
    });

    _viewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isSuccessfullyLoggedIn) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _appPreferences.setUserLoggedIn();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.primary),
        backgroundColor: ColorManager.white,
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return Center(
            child: snapshot.data?.getScreenWidget(
                  context,
                  _getContentWidget(),
                  () => _viewModel.register(),
                ) ??
                _getContentWidget(),
          );
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: EdgeInsets.only(top: AppPadding.p30),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image(image: AssetImage(ImageAssets.splashLogo)),
              SizedBox(height: AppSize.s12),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorUserName,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _userNameEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.username.tr(),
                        labelText: AppStrings.username.tr(),
                        errorText: snapshot.data,
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppPadding.p12,
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CountryCodePicker(
                          initialSelection: "+55",
                          showCountryOnly: true,
                          showOnlyCountryWhenClosed: true,
                          hideMainText: true,
                          favorite: ["+966", "+02", "+39", "+55"],
                          onChanged: (country) {
                            // update view model with the selected code
                            _viewModel.setCountryMobileCode(
                                country.dialCode ?? EMPTY);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorMobileNumber,
                          builder: (context, snapshot) {
                            return TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _mobileNumberEditingController,
                              decoration: InputDecoration(
                                hintText: AppStrings.mobileNumber.tr(),
                                labelText: AppStrings.mobileNumber.tr(),
                                errorText: snapshot.data,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.s12),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorEmail,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.emailHint.tr(),
                        labelText: AppStrings.emailHint.tr(),
                        errorText: snapshot.data,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSize.s12),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorPassword,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.password.tr(),
                        labelText: AppStrings.password.tr(),
                        errorText: snapshot.data,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppSize.s12),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Container(
                  height: AppSize.s46,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorManager.grey,
                        width: AppSize.s1_5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: AppSize.s12),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () => _viewModel.register()
                            : null,
                        child: Text(AppStrings.register).tr(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.haveAccount,
                    style: Theme.of(context).textTheme.subtitle2,
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMediaWidget() {
    return Container(
        padding: EdgeInsets.only(left: AppPadding.p6, right: AppPadding.p12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                AppStrings.profilePicture,
                style: Theme.of(context).inputDecorationTheme.labelStyle,
              ).tr(),
            ),
            Flexible(
                child: StreamBuilder<File?>(
              stream: _viewModel.outputProfilePicture,
              builder: (context, snapshot) {
                return _imagePickedByUser(snapshot.data);
              },
            )),
            Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc)),
          ],
        ));
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                leading: Icon(Icons.camera),
                title: Text(AppStrings.photoGallery).tr(),
                onTap: () {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                leading: Icon(Icons.camera_alt_rounded),
                title: Text(AppStrings.photoCamera).tr(),
                onTap: () {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  _imageFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }
}
