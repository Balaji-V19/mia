import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mia/constants/app_colors.dart';
import 'package:mia/constants/app_textstyle.dart';
import 'package:mia/constants/string_constants.dart';
import '../constants/image_constants.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Stack(
          children: [
            Positioned(
              left: 0.0,
              child: Image.asset(
                ImageConstants.bgImageWebp,
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
              ),
            ),
            SvgPicture.asset(
              ImageConstants.stars,
              width: ScreenUtil().screenWidth * 0.4,
              height: ScreenUtil().screenHeight,
            ),
            Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: SizedBox(
                  width: ScreenUtil().screenWidth * 0.6,
                  height: ScreenUtil().screenHeight,
                  child: Column(
                    children: [
                      const Spacer(),
                      Text(
                        "Meet",
                        style: AppTextStyles.text14w500
                            .copyWith(color: AppColors.textBlue),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: SvgPicture.asset(
                          ImageConstants.mia,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Text(
                          "Your Ai interviewer for this round",
                          style: AppTextStyles.text14w500
                              .copyWith(color: AppColors.textBlue),
                        ),
                      ),
                      GradientProgressBar(loadingDuration: 5),
                      const Spacer(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}


class GradientProgressBar extends StatefulWidget {
  int loadingDuration = 0;
  GradientProgressBar({required this.loadingDuration});
  @override
  _GradientProgressBarState createState() => _GradientProgressBarState();
}

class _GradientProgressBarState extends State<GradientProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.loadingDuration),
      vsync: this,
    )..addListener(() {
      if (_controller.isCompleted) {
        Navigator.pushNamed(context, StringConstants.INTERVIEW_SCREEN);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.h)
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xff210E52), Color(0xff6938EF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}