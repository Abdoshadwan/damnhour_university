import 'package:damnhour_university/modules/complaints/complaintsform.dart';
import 'package:damnhour_university/modules/complaints/suggestionsform.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../icons/custom_icons.dart';
import '../../models/home_model.dart';
import '../../shared/components/components.dart';
import '../../shared/constants/constants.dart';
import '../../shared/styles/colors.dart';
import '../notifications/notifications.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        displacement: 10.0,
        color: Colors.white,
        backgroundColor: accent_orange,
        onRefresh: () async {
          UniversityCubit.get(context).getComplaintsAndSuggestions();
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: ScreenSize.height * 0.055,
                  start: ScreenSize.width * 0.04,
                  end: ScreenSize.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: accentColor50,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              navigateTo(to: Notifications(), context: context);
                            },
                            icon: Icon(
                              Icons.notifications_none,
                              color: primary_blue,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextCairo(
                                text: 'جامعة دمنهور',
                                color: accent_orange,
                                fontweight: FontWeight.w400,
                                fontsize: 13.0,
                              ),
                              TextCairo(
                                text: 'الشكاوي والمقترحات',
                                color: Colors.black,
                                fontweight: FontWeight.w500,
                                fontsize: 16.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15.0),
                        Container(
                          height: 52,
                          child: Image(
                            image: AssetImage("assets/images/logo.png"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: accent_orange),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: 20.0,
                          top: 6.0,
                        ),
                        child: TextField(
                          onChanged: (s) {
                            UniversityCubit.get(context).filterPostsBySearch(s);
                          },
                          controller: searchController,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            hintText: "ما الذي تبحث عنه؟",
                            hintStyle: TextStyle(
                              color: accentColor100,
                              fontFamily: 'Cairo',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding: EdgeInsetsDirectional.only(start: 10.0),
                              child: Icon(Icons.search, color: accentColor100),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextCairo(
                      text: 'كيف يمكننا مساعدتك اليوم ؟',
                      fontweight: FontWeight.w500,
                      fontsize: 18.0,
                      color: Colors.black,
                    ),
                    SizedBox(height: 10.0),
                    homeTextField('ارسال شكوي', context, () {
                      navigateTo(to: ComplaintsForm(), context: context);
                    }),
                    SizedBox(height: 10.0),
                    homeTextField('ارسال اقتراح', context, () {
                      navigateTo(to: SuggestionsForm(), context: context);
                    }),
                    SizedBox(height: 10.0),
                    homeTextField(
                      'متابعة الطلبات',
                      context,
                      () => UniversityCubit.get(context).changeBottomNav(1),
                    ),
                    SizedBox(height: 20.0),
                    TextCairo(
                      text: 'أبرز الشكاوي والاقتراحات',
                      color: Colors.black,
                      fontsize: 18.0,
                      fontweight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              BlocConsumer<UniversityCubit, UniversityStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  var cubit = UniversityCubit.get(context);

                  if (cubit.searchedPosts.isNotEmpty) {
                    return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder:
                          (context, index) => buildPostItemForHome(
                            context,
                            cubit.searchedPosts[index],
                          ),
                      separatorBuilder:
                          (context, index) => Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                              vertical: ScreenSize.height * 0.02,
                            ),
                            child: Container(height: 1, color: brandColor25),
                          ),
                      itemCount: cubit.searchedPosts.length,
                    );
                  }

                  if (state is GetAllComplaintsAndSuggestionsLoadingState) {
                    return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => buildShimmerPostItem(),
                      separatorBuilder:
                          (context, index) => SizedBox(height: 20),
                      itemCount: 5,
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: ScreenSize.width * 0.04,
                          bottom: ScreenSize.height * 0.02,
                        ),
                        child: sectorsListView(
                          onTap: (String sectorName) {
                            cubit.filterPostsBySector(sectorName);
                          },
                        ),
                      ),
                      Container(height: 1.0, color: brandColor25),
                      if (cubit.repliedPosts.isEmpty)
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: ScreenSize.height * 0.02,
                          ),
                          child: Center(
                            child: TextCairo(
                              text: ' لا يوجد شكاوي او اقتراحات حتي الان',
                              color: accent_orange,
                            ),
                          ),
                        ),
                      if (cubit.repliedPosts.isNotEmpty)
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder:
                              (context, index) => buildPostItemForHome(
                                context,
                                cubit.repliedPosts[index],
                              ),
                          separatorBuilder:
                              (context, index) => Padding(
                                padding: EdgeInsetsDirectional.symmetric(
                                  vertical: ScreenSize.height * 0.02,
                                ),
                                child: Container(
                                  height: 1,
                                  color: brandColor25,
                                ),
                              ),
                          itemCount: cubit.repliedPosts.length,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeTextField(
    String text,
    BuildContext context,
    VoidCallback function,
  ) => InkWell(
    child: Container(
      height: ScreenSize.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: primary_blue),
      ),
      child: Row(
        children: [
          Icon(CustomIcons.keyboard_arrow_left, color: primary_blue),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 20.0),
                child: TextCairo(
                  text: text,
                  color: Colors.black,
                  fontweight: FontWeight.w500,
                  fontsize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    onTap: function,
  );

  Widget buildShimmerPostItem() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.width * 0.04,
        vertical: ScreenSize.height * 0.01,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: ScreenSize.width * 0.25,
                        height: ScreenSize.height * 0.04,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: ScreenSize.width * 0.22,
                                height: ScreenSize.height * 0.018,
                                color: Colors.white,
                              ),
                              SizedBox(width: ScreenSize.width * 0.02),
                              Container(
                                width: ScreenSize.width * 0.22,
                                height: ScreenSize.height * 0.018,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenSize.height * 0.008),
                          Container(
                            width: ScreenSize.width * 0.15,
                            height: ScreenSize.height * 0.013,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ScreenSize.width * 0.04),
                Container(
                  width: ScreenSize.width * 0.13,
                  height: ScreenSize.width * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenSize.height * 0.012),
            Container(
              height: ScreenSize.height * 0.18,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.012),
            Container(
              width: double.infinity,
              height: ScreenSize.height * 0.018,
              color: Colors.white,
            ),
            SizedBox(height: ScreenSize.height * 0.008),
            Container(
              width: ScreenSize.width * 0.7,
              height: ScreenSize.height * 0.018,
              color: Colors.white,
            ),
            SizedBox(height: ScreenSize.height * 0.012),
            Container(
              height: ScreenSize.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostItemForHome(context, ItemModel model) {
    var cubit = UniversityCubit.get(context);
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ScreenSize.width * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextCairo(
                          color: brand,
                          text: model.created_at ?? '',
                          fontsize: 14.0,
                          fontweight: FontWeight.w400,
                        ),
                        SizedBox(width: ScreenSize.width * 0.04),
                        TextCairo(
                          text: getTwoPartName(model.user?.username),
                          color: primary_blue,
                          fontsize: 14.0,
                          fontweight: FontWeight.w400,
                        ),
                      ],
                    ),
                    TextCairo(
                      text: model.user?.faculty ?? '',
                      color: accent_orange,
                      fontsize: 10.0,
                      fontweight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  UniversityCubit.get(context).changeBottomNav(0);
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(model.user!.profile_image!),
                  radius: 25.0,
                ),
                //  Container(
                //   width: ScreenSize.width * 0.14,
                //   height: ScreenSize.width * 0.14,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     image: DecorationImage(
                //       image: cubit.profileImageProvider,
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),
              ),
            ],
          ),

          if (model.attachments != null)
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10.0),
              child:
                  cubit.getFileType(model.attachments) == 'Image'
                      ? Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(model.attachments ?? ''),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                      : Container(
                        height: 150,
                        width: double.infinity,
                        child: SvgPicture.asset('assets/images/pdf.svg'),
                      ),
            ),

          SizedBox(height: .01 * ScreenSize.height),

          TextCairo(
            text: ' ${model.title}',
            color: Colors.black,
            fontweight: FontWeight.w600,
          ),

          SizedBox(height: .01 * ScreenSize.height),

          TextCairo(
            heightoftext: 1.5,
            textalign: TextAlign.right,
            text: model.description ?? '',
            fontweight: FontWeight.w400,
            fontsize: 14.0,
            color: Colors.black,
          ),

          SizedBox(height: 10.0),

          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: ScreenSize.width * 0.05,
            ),
            width: double.infinity,
            height: ScreenSize.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: neutralColor25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenSize.width * 0.02),
                      TextCairo(
                        text: '${model.dislike_count}',
                        color: Colors.black,
                      ),
                      Container(
                        width: ScreenSize.width * 0.15,
                        height: ScreenSize.height * 0.045,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          onPressed: () {
                            cubit.changedisdislike(model);
                          },
                          icon: Icon(
                            Icons.thumb_down_alt_outlined,
                            color:
                                model.isdislike == true
                                    ? Colors.red
                                    : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: ScreenSize.width * 0.02),
                      TextCairo(
                        text: '${model.like_count}',
                        color: Colors.black,
                      ),
                      Container(
                        width: ScreenSize.width * 0.15,
                        height: ScreenSize.height * 0.045,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            cubit.changelike(model);
                          },
                          icon: Icon(
                            Icons.thumb_up_alt_outlined,
                            color:
                                model.islike == true
                                    ? Colors.green
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: ScreenSize.width * 0.05,
                  ),
                  child: TextCairo(
                    text: 'هل هذه الشكوى حقيقية ؟',
                    fontsize: 13.0,
                    fontweight: FontWeight.w400,
                    color: primary_blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String getTwoPartName(String? fullName) {
  final parts = fullName!.trim().split(' ');
  return '${parts[0]} ${parts[1]}';
}
