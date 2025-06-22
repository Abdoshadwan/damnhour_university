// ignore_for_file: must_be_immutable

import 'package:damnhour_university/admin/modules/CreateAccount/CreateAccount.dart';
import 'package:damnhour_university/shared/components/components.dart';
import 'package:damnhour_university/shared/constants/constants.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/cubit/states.dart';
import 'package:damnhour_university/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfile extends StatelessWidget {
  AdminProfile({super.key});

  // Example admin data (replace with real data source if available)
  TextEditingController nameController = TextEditingController(
    text: 'محمد طلعت بسيوني',
  );
  TextEditingController emailController = TextEditingController(
    text: 'mohamedbasiouny@gmail.com',
  );
  TextEditingController sectorController = TextEditingController(
    text: 'شئون التعليم',
  );
  TextEditingController phoneController = TextEditingController(
    text: '01111111111',
  );

  // Example complaints stats (replace with real data source if available)
  //will get from cubit
  final int complaintsUnderReview = 8;
  final int complaintsResolved = 250;

  @override
  Widget build(BuildContext context) {
    var cubit = UniversityCubit.get(context);
    nameController.text = cubit.profilemodel?.username ?? 'محمد طلعت بسيوني';
    emailController.text =
        cubit.profilemodel?.email ?? 'mohamedbasiouny@gmail.com';
    sectorController.text = cubit.profilemodel?.sector_admin ?? 'شئون التعليم';
    phoneController.text = cubit.profilemodel?.phone ?? '01111111111';
    ScreenSize.initscreensize(context);
    return BlocConsumer<UniversityCubit, UniversityStates>(
      listener: (context, state) {
        if (state is UpdateProfileInfoSuccessState) {
          showtoast(message: 'تم التحديث بنجاح', color: Colors.green);
        }
        if (state is UpdateProfileInfoErrorState) {
          showtoast(message: 'برجاء المحاوله مره اخرى', color: Colors.red);
        }
      },
      builder:
          (context, state) => Scaffold(
            backgroundColor: primary_blue,
            body: Column(
              children: [
                // Top section: profile image, name, sector
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
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextCairo(
                              text:
                                  UniversityCubit.get(
                                    context,
                                  ).profilemodel?.username ??
                                  '',
                              fontweight: FontWeight.w400,
                              fontsize: 14.0,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5),
                            TextCairo(
                              text:
                                  UniversityCubit.get(
                                    context,
                                  ).profilemodel?.sector_admin ??
                                  '',
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
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
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
                // Stats cards

                // White container with admin info fields
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ScreenSize.width * 0.05),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenSize.width * 0.05,
                              vertical: ScreenSize.height * 0.02,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 117 / 812 * ScreenSize.height,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFA726), // Orange
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top:
                                              .125 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          left:
                                              .125 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          child: Icon(
                                            Icons.pending_actions,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        Positioned(
                                          bottom:
                                              .08 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          right:
                                              .08 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 4),
                                              TextCairo(
                                                text:
                                                    cubit.pendingS_C.length
                                                        .toString(),
                                                color: Colors.white,
                                                fontsize: 20,
                                                fontweight: FontWeight.bold,
                                              ),
                                              TextCairo(
                                                text: 'عدد الشكاوى المعلَّقه ',
                                                color: Colors.white,
                                                fontsize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    height: 117 / 812 * ScreenSize.height,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4CAF50), // Green
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top:
                                              .125 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          left:
                                              .125 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          child: Icon(
                                            Icons.file_copy_outlined,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        Positioned(
                                          bottom:
                                              .08 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          right:
                                              .08 *
                                              117 /
                                              812 *
                                              ScreenSize.height,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 4),
                                              TextCairo(
                                                text:
                                                    cubit.repliedS_C.length
                                                        .toString(),
                                                color: Colors.white,
                                                fontsize: 20,
                                                fontweight: FontWeight.bold,
                                              ),
                                              TextCairo(
                                                text: 'عدد الشكاوى المعالجة',
                                                color: Colors.white,
                                                fontsize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenSize.height * 0.01),
                          CustomTextFeild(
                            toptext: 'الاسم الكامل',
                            controller: nameController,
                            inputType: TextInputType.name,
                            enabled: false,
                          ),

                          CustomTextFeild(
                            toptext: 'البريد الإلكتروني',
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            enabled: false,
                          ),
                          CustomTextFeild(
                            toptext: 'القطاع',
                            controller: sectorController,
                            inputType: TextInputType.text,
                            enabled: false,
                          ),
                          CustomTextFeild(
                            toptext: 'رقم الهاتف',
                            controller: phoneController,
                            inputType: TextInputType.phone,
                            enabled: false,
                          ),
                          SizedBox(height: 15),
                          Button(
                            text: 'تسجيل حساب جديد',
                            onpressed: () {
                              navigateTo(to: CreateAccount(), context: context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
