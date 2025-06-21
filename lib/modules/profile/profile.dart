import 'package:damnhour_university/modules/login/login.dart';
import 'package:damnhour_university/modules/profile/personal_information/personal_information.dart';
import 'package:damnhour_university/modules/profile/protection_safety/protection_safety.dart';
import 'package:damnhour_university/modules/profile/questions/questions.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/cubit/states.dart';
import 'package:damnhour_university/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../shared/components/components.dart';
import '../../shared/constants/constants.dart';
import '../../shared/styles/colors.dart';
import 'help_center/help_center.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UniversityCubit, UniversityStates>(
      listener: (context, state) {
        if (state is UpdateProfileInfoSuccessState) {
          showtoast(message: 'تم التحديث بنجاح', color: Colors.green);
        }
      },
      builder: (context, state) {
        var cubit = UniversityCubit.get(context);
        return Scaffold(
          backgroundColor: primary_blue,
          body: Column(
            children: [
              // الجزء الصورة والاسم
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.width * 0.05,
                  vertical: ScreenSize.height * 0.05,
                ),
                color: primary_blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextCairo(
                            text: cubit.nameController.text,
                            fontweight: FontWeight.w400,
                            fontsize: 14.0,
                            color: Colors.white,
                          ),
                          TextCairo(
                            text: cubit.profilemodel?.faculty ?? '',
                            fontweight: FontWeight.w600,
                            fontsize: 14.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: ScreenSize.width * 0.03),
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        state is! UpdateProfileInfoLoadingState
                            ? Container(
                              width: ScreenSize.width * 0.2,
                              height: ScreenSize.width * 0.2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: cubit.profileImageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                            : Container(
                              width: ScreenSize.width * 0.2,
                              height: ScreenSize.width * 0.2,
                              child: Center(child: CircularProgressIndicator()),
                            ),

                        InkWell(
                          child: Container(
                            height: ScreenSize.width * 0.06,
                            width: ScreenSize.width * 0.06,
                            decoration: BoxDecoration(
                              color: accent_orange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: ScreenSize.width * 0.04,
                            ),
                          ),
                          onTap: () {
                            cubit.updateProfileImage();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // جزء ال container
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ScreenSize.width * 0.05),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextCairo(
                          text: 'معلومات المستخدم الشخصية',
                          fontweight: FontWeight.w600,
                          fontsize: 16.0, // Fixed font size
                          color: Colors.black,
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        profileItem(
                          text: 'المعلومات الشخصية',
                          icon: Icons.person_2_outlined,
                          context: context,

                          OnPress: () {
                            navigateTo(
                              to: PersonalInformation(),
                              context: context,
                            );
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        profileItem(
                          text: 'الحماية والأمان ',
                          icon: Icons.verified_user_outlined,
                          context: context,

                          OnPress: () {
                            navigateTo(
                              to: ProtectionSafety(),
                              context: context,
                            );
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        profileItem(
                          text: 'الأسئلة الشائعة',
                          icon: Icons.help_outline,
                          context: context,

                          OnPress: () {
                            navigateTo(to: Questions(), context: context);
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        profileItem(
                          text: 'مركز المساعدة',
                          context: context,

                          OnPress: () {
                            navigateTo(to: HelpCenter(), context: context);
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        profileItem(
                          iconcolor: Colors.red,
                          icon: Icons.logout,
                          text: 'تسجيل خروج',
                          context: context,
                          OnPress: () {
                            UniversityCubit.get(context).currentIndex = 3;
                            Cache_Helper.removedata(key: 'token').then((value) {
                              navigatet_close(context: context, to: Login());
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget profileItem({
  required String text,
  IconData? icon,
  String? image,
  required context,

  Color iconcolor = const Color.fromRGBO(0, 9, 69, 1),
  required void Function()? OnPress,
}) => Container(
  padding: EdgeInsets.symmetric(horizontal: ScreenSize.width * 0.03),
  child: Row(
    children: [
      IconButton(
        onPressed: OnPress,
        icon: Icon(
          Icons.arrow_back_ios,
          size: ScreenSize.width * 0.04,
          color: brandColor200,
        ),
      ),
      SizedBox(width: ScreenSize.width * 0.025),
      Expanded(
        child: TextCairo(
          text: text,
          fontweight: FontWeight.w600,
          fontsize: 14.0,
          color: brand,
          textalign: TextAlign.end,
        ),
      ),
      SizedBox(width: ScreenSize.width * 0.025),
      if (icon == null)
        SvgPicture.asset(
          'assets/images/help.svg',
          height: ScreenSize.width * 0.05,
          width: ScreenSize.width * 0.05,
          colorFilter: ColorFilter.mode(iconcolor, BlendMode.srcIn),
        )
      else
        Icon(icon, color: iconcolor, size: ScreenSize.width * 0.06),
    ],
  ),
);
