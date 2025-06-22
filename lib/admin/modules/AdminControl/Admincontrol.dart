// ignore_for_file: must_be_immutable
import 'package:damnhour_university/admin/modules/AdminControl/AdminReply.dart';
import 'package:damnhour_university/admin/modules/AdminHome/AdminHome.dart';
import 'package:damnhour_university/admin/modules/AdminNotification/AdminNotification.dart';
import 'package:damnhour_university/models/home_model.dart';
import 'package:damnhour_university/shared/components/components.dart';
import 'package:damnhour_university/shared/constants/constants.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/cubit/states.dart';
import 'package:damnhour_university/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AdminControl extends StatelessWidget {
  AdminControl({super.key});
  TextEditingController searchcontroller = TextEditingController();
  String? selectedvalue;
  @override
  Widget build(BuildContext context) {
    var cubit = UniversityCubit.get(context);
    return BlocConsumer<UniversityCubit, UniversityStates>(
      listener: (context, state) {},
      builder:
          (context, state) => RefreshIndicator(
            displacement: 10.0,
            color: Colors.white,
            backgroundColor: accent_orange,
            onRefresh: () async {
              UniversityCubit.get(context).getComplaintsAndSuggestions();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
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
                                    navigateTo(
                                      to: AdminNotification(),
                                      context: context,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.notifications_none,
                                    color: primary_blue,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextCairo(
                                      text: 'جامعة دمنهور',
                                      color: accent_orange,
                                      fontweight: FontWeight.w400,
                                      fontsize: 13.0,
                                    ),
                                    TextCairo(
                                      text: 'صفحة التحكم',
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
                          SizedBox(height: 30),
                          TextCairo(
                            text: ' الشكاوي والاقتراحات',
                            color: Colors.black,
                            fontsize: 18.0,
                            fontweight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width * 0.06,
                      ),
                      child: Row(
                        children: [
                          // Dropdown
                          dropdownlist(
                            dropdownitems: [
                              'معلق',
                              'قيد التنفيذ',
                              'تم الحل',
                              'مرفوض',
                            ],
                            hinttext: '',
                            bordercolor: brandColor200,
                            onchanged: (value) {
                              UniversityCubit.get(
                                context,
                              ).filterPostsBySectorandstatus(status: value);
                            },
                            width: 104,
                            selectedvalue: selectedvalue,
                          ),
                          SizedBox(width: 8),
                          // Search field
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: brandColor200),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Icon(
                                      Icons.search,
                                      color: accentColor100,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        print(
                                          UniversityCubit.get(
                                            context,
                                          ).filteredPostsbystatus.length,
                                        );
                                        UniversityCubit.get(
                                          context,
                                        ).updateSearchId(value);
                                      },
                                      // controller: searchcontroller,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: "ابحث برقم الشكوى",
                                        hintStyle: TextStyle(
                                          color: accentColor100,
                                          fontFamily: 'Cairo',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
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

                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: ScreenSize.width * 0.04,
                        bottom: ScreenSize.height * 0.02,
                      ),
                      child: sectorsListView(
                        onTap: (String sectorName) {
                          UniversityCubit.get(
                            context,
                          ).filterPostsBySector(sectorName);
                        },
                      ), //=>
                    ),
                    Container(height: 1.0, color: brandColor25),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder:
                          (context, index) => buildPostItem(
                            context,
                            UniversityCubit.get(
                              context,
                            ).filteredPostsbystatus[index],
                            cubit,
                          ),
                      separatorBuilder:
                          (context, index) => Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                              vertical: ScreenSize.height * 0.02,
                            ),
                            // child: Container(height: 1, color: brandColor25),
                          ),
                      itemCount:
                          UniversityCubit.get(
                            context,
                          ).filteredPostsbystatus.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget buildPostItem(
    context,
    ItemModel model,
    UniversityCubit cubit,
  ) => Padding(
    padding: EdgeInsets.symmetric(horizontal: ScreenSize.width * 0.02),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: model.sc_type == 'شكوى' ? Colors.red : Colors.green,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsetsDirectional.symmetric(
        vertical: ScreenSize.height * 0.02,
        horizontal: ScreenSize.width * 0.04,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    statusof(
                      text: model.status ?? '',
                      color:
                          model.status == "معلق"
                              ? Colors.amberAccent
                              : model.status == "قيد التنفيذ"
                              ? brandColor200
                              : model.status == "مرفوض"
                              ? Colors.red
                              : Colors.green,
                    ),
                    SizedBox(width: .035 * ScreenSize.width),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextCairo(
                                text: model.created_at ?? '',
                                color: brand,
                                fontsize: 14.0,
                                fontweight: FontWeight.w400,
                              ),
                              SizedBox(width: .018 * ScreenSize.width),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: .25 * ScreenSize.width,
                                  child: TextCairo(
                                    text: getTwoPartName(model.user?.username),
                                    color: primary_blue,
                                    fontsize: 14.0,
                                    fontweight: FontWeight.w400,
                                  ),
                                ),
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
                  ],
                ),
              ),
              SizedBox(width: .01 * ScreenSize.width),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(model.user!.profile_image!),
                    radius: 25.0,
                  ),
                ),
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
          if (model.attachments == null) SizedBox(height: 30),
          SizedBox(height: .01 * ScreenSize.height),
          TextCairo(
            text: ' ${model.title}',
            color: Colors.black,
            fontweight: FontWeight.w600,
          ),
          SizedBox(height: .01 * ScreenSize.height),

          TextCairo(
            textalign: TextAlign.right,
            text: model.description ?? '',
            fontweight: FontWeight.w400,
            fontsize: 14.0,
            color: Colors.black,
          ),
          if (model.attachments == null) SizedBox(height: 30),
          SizedBox(height: 10.0),
          Button(
            text: 'فتح',
            onpressed: () {
              UniversityCubit.get(context).resetselectedstatus();
              navigateTo(
                to: AdminReply(
                  model: model,
                  date: model.created_at,
                  statuscolor:
                      model.status == "معلق"
                          ? Colors.amberAccent
                          : model.status == "قيد التنفيذ"
                          ? brandColor200
                          : model.status == "مرفوض"
                          ? Colors.red
                          : Colors.green,
                ),
                context: context,
              );
            },
          ),
        ],
      ),
    ),
  );
  Widget statusof({
    required String text,
    required Color color,
    IconData? icon = Icons.folder_outlined,
  }) => Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: Icon(icon, color: Colors.white)),
        Expanded(
          flex: 2,
          child: TextCairo(
            text: text,
            fontsize: 12,
            fontweight: FontWeight.bold,
            textalign: TextAlign.right,
          ),
        ),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 8),
    width: 100,
    height: 34,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
