import 'package:damnhour_university/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/components.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';
import '../../../shared/styles/colors.dart';

class HelpCenter extends StatelessWidget {
  HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UniversityCubit, UniversityStates>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        var cubit = UniversityCubit.get(context);
        return Scaffold(
          backgroundColor: primary_blue,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // الـ Header الأزرق
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
                        flex: 1,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            navigatet_close(
                              to: LayoutScreen(),
                              context: context,
                            );
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      Expanded(
                        flex: 7,
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
                              text: cubit.profilemodel!.faculty ?? '',
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
                          Container(
                            width: ScreenSize.width * 0.2,
                            height: ScreenSize.width * 0.2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: cubit.profileImageProvider,
                                fit: BoxFit.fill,
                              ),
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
                // الـ Container الأبيض
                Container(
                  width: double.infinity,
                  height: ScreenSize.height - (ScreenSize.height * 0.15),
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
                          text: 'مركز المساعدة',
                          color: Colors.black,
                          textalign: TextAlign.end,
                        ),
                        SizedBox(height: 25.0),
                        TextCairo(
                          text: '!مرحبًا بك في صفحة الدعم والمساعدة',
                          color: primary_blue,
                        ),
                        SizedBox(height: 15.0),
                        TextCairo(
                          text:
                              'هنا ستجد كل ما تحتاج معرفته لاستخدام تطبيق الشكاوى بسهولة وفعالية',
                          fontsize: 14.0,
                          color: Colors.black,
                          textalign: TextAlign.end,
                        ),
                        SizedBox(height: 15.0),

                        Column(
                          children: List.generate(
                            cubit.helpCenter.length,
                            (index) => customExpansionTile(
                              question: cubit.helpCenter[index]['question']!,
                              answer: cubit.helpCenter[index]['answer']!,
                              index: index,
                              context: context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget customExpansionTile({
  required Widget question,
  required Widget answer,
  required int index,
  required BuildContext context,
}) {
  return BlocBuilder<UniversityCubit, UniversityStates>(
    builder: (context, state) {
      bool isExpanded =
          UniversityCubit.get(context).expandedTilesHelpCenter[index] ?? false;
      return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        collapsedIconColor: Colors.black,
        iconColor: Colors.black,
        showTrailingIcon: false,
        leading: AnimatedRotation(
          turns: isExpanded ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
        title: Align(alignment: Alignment.centerRight, child: question),
        onExpansionChanged: (bool expanded) {
          UniversityCubit.get(context).toggleTileExpandedHelpCenter(index);
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: answer,
          ),
        ],
      );
    },
  );
}
