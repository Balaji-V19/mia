import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mia/constants/app_colors.dart';

import '../constants/image_constants.dart';
import '../constants/string_constants.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          StringConstants.HOME_SCREEN,
              (Route<dynamic> route) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SvgPicture.asset(ImageConstants.stars, width: ScreenUtil().screenWidth, height: ScreenUtil().screenHeight,)
    );
  }
}
