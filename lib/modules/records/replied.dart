// ignore_for_file: must_be_immutable

import 'package:damnhour_university/admin/modules/AdminControl/pdfviewer.dart';
import 'package:damnhour_university/admin/modules/AdminHome/AdminHome.dart';
import 'package:damnhour_university/layout/layout.dart';
import 'package:damnhour_university/models/home_model.dart';
import 'package:damnhour_university/shared/components/components.dart';
import 'package:damnhour_university/shared/constants/constants.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/cubit/states.dart';
import 'package:damnhour_university/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Replied extends StatelessWidget {
  ItemModel model;

  String? date;

  Color? statuscolor;

  Replied({super.key, required this.model, this.date, this.statuscolor});
  @override
  Widget build(BuildContext context) {
    TextEditingController response = TextEditingController(
      text: '${model.response}',
    );
    var cubit = UniversityCubit.get(context);
    var _formkey = GlobalKey<FormState>();
    return BlocConsumer<UniversityCubit, UniversityStates>(
      listener: (context, state) {},
      builder:
          (context, state) => Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width * 0.04,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: primary_blue,
                              ),
                              onPressed:
                                  () => navigatet_close(
                                    context: context,
                                    to: LayoutScreen(),
                                  ),
                            ),
                            Expanded(
                              child: Center(
                                child: TextCairo(
                                  text: 'الرد علي الشكوي',
                                  color: primary_blue,
                                  fontsize: 18,
                                  fontweight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Complaint Card
                      cubit.getFileType(model.attachments) == 'pdf'
                          ? InkWell(
                            child: complaintcard(cubit),
                            onTap: () {
                              print(model.attachments);
                              navigateTo(
                                to: PDFViewerPage(url: model.attachments ?? ''),
                                context: context,
                              );
                            },
                          )
                          : complaintcard(cubit),
                      SizedBox(height: 16),

                      // Dropdown for status
                      SizedBox(height: .1 * ScreenSize.height),
                      TextCairo(
                        text: 'نص الرد',
                        color: Colors.black,
                        textalign: TextAlign.end,
                      ),
                      SizedBox(height: 16),
                      // Reply text field
                      Form(
                        key: _formkey,
                        child: Container(
                          width: 327 / 375 * ScreenSize.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: brandColor25),
                          ),
                          child: TextFormField(
                            textAlign: TextAlign.end,
                            maxLines: 4,
                            enabled: false,
                            textDirection: TextDirection.ltr,
                            decoration: InputDecoration(
                              hintText: '${response.text}',
                              hintStyle: TextStyle(
                                color: brandColor200,
                                fontFamily: 'Cairo',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget complaintcard(UniversityCubit cubit) => Container(
    width: 327 / 375 * ScreenSize.width,
    margin: EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: brandColor25),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // User info row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statuscolor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.school, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    TextCairo(
                      text: model.status ?? '',
                      color: Colors.white,
                      fontsize: 12,
                      fontweight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // Time
              TextCairo(
                text: date ?? '',
                color: brandColor200,
                fontsize: 12,
                fontweight: FontWeight.w400,
              ),
              SizedBox(width: 8),
              // Name and faculty
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextCairo(
                      text: getTwoPartName(model.user?.username),
                      color: primary_blue,
                      fontsize: 13,
                      fontweight: FontWeight.w700,
                    ),
                    TextCairo(
                      text: model.user?.faculty ?? '',
                      color: accent_orange,
                      fontsize: 11,
                      fontweight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // Profile image
              CircleAvatar(
                backgroundImage: NetworkImage(model.user!.profile_image!),
                radius: 18,
              ),
            ],
          ),
        ),
        // Image
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
        // Description
        if (model.attachments == null) SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextCairo(
            text: model.description ?? '',
            color: Colors.black,
            fontsize: 12,
            fontweight: FontWeight.w400,
            textalign: TextAlign.right,
          ),
        ),
        if (model.attachments == null) SizedBox(height: 30),
      ],
    ),
  );
}
