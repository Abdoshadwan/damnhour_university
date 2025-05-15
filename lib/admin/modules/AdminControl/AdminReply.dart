// ignore_for_file: must_be_immutable

import 'package:damnhour_university/admin/modules/AdminControl/Admincontrol.dart';
import 'package:damnhour_university/admin/modules/AdminHome/AdminHome.dart';
import 'package:damnhour_university/admin/modules/AdminLayout/AdminLayout.dart';
import 'package:damnhour_university/shared/components/components.dart';
import 'package:damnhour_university/shared/constants/constants.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/cubit/states.dart';
import 'package:damnhour_university/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminReply extends StatelessWidget {
  String? attachments;
  String? name;
  String? faculty;
  String? date;
  String? status;
  Color? statuscolor;
  String? description;
  String? type_S_C;
  int? id;
  AdminReply({
    super.key,
    this.attachments,
    this.date,
    this.description,
    this.faculty,
    this.id,
    this.name,
    this.status,
    this.statuscolor,
    this.type_S_C,
  });
  TextEditingController replyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit = UniversityCubit.get(context);
    var _formkey = GlobalKey<FormState>();
    return BlocConsumer<UniversityCubit, UniversityStates>(
      listener: (context, state) {
        if (state is updateS_CSuccessState) {
          showtoast(message: 'تم التحديث بنجاح', color: Colors.green);
          navigatet_close(context: context, to: AdminLayout());
          cubit.resetselectedstatus();
        } else if (state is updateS_CErrorState) {
          showtoast(
            message: cubit.updates_c_model?.message ?? 'حدث خطأ ما',
            color: Colors.red,
          );
        } else if (state is deleteS_CSuccessState) {
          showtoast(message: 'تم الحذف بنجاح', color: Colors.green);
          navigatet_close(context: context, to: AdminControl());
        } else if (state is deleteS_CErrorState) {
          showtoast(message: '${state.error}', color: Colors.red);
        }
      },
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
                                    to: AdminLayout(),
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
                            IconButton(
                              onPressed: () {
                                cubit.deleteS_C(
                                  id: id.toString(),
                                  type_S_C: type_S_C,
                                );
                              },
                              icon: Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Complaint Card
                      complaintcard(),
                      SizedBox(height: 16),
                      // Dropdown for status
                      dropdownlist(
                        title: 'حالة الشكوى',
                        selectedvalue: cubit.selectedstatus,
                        hinttext: '',
                        dropdownitems: [
                          'مرفوض',
                          'معلق',
                          'قيد التنفيذ',
                          'تم الحل',
                        ],
                        onchanged: (value) {
                          cubit.changeselectedstatus(value);
                        },
                        dropIcon: Icons.info_outlined,
                        bordercolor: cubit.statusBorderColor,
                      ),
                      SizedBox(height: 16),
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'نص الرد مطلوب';
                              }
                              return null;
                            },
                            textAlign: TextAlign.end,
                            controller: replyController,
                            maxLines: 4,
                            textDirection: TextDirection.ltr,
                            decoration: InputDecoration(
                              hintText:
                                  'يجب كتابة رد واضح ووسمي، يوضح الاجراءات المتخذة أو حالة المعالجة.',
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
                      // Send and Cancel buttons
                      state is! updateS_CLoadingState
                          ? Button(
                            text: 'إرسال',
                            onpressed: () {
                              cubit.validateStatus();
                              if (_formkey.currentState!.validate() &&
                                  cubit.isStatusValid) {
                                cubit.updateS_C(
                                  id: id.toString(),
                                  type_S_C: type_S_C,
                                  response: replyController.text,
                                  status: cubit.selectedstatus,
                                );
                              }
                            },
                            color: primary_blue,
                            textcolor: Colors.white,
                          )
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(height: 12),
                      Button(
                        text: 'الغاء',
                        onpressed:
                            () => navigatet_close(
                              context: context,
                              to: AdminLayout(),
                            ),
                        color: Colors.white,
                        textcolor: primary_blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget complaintcard() => Container(
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
                  color: brandColor200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.school, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    TextCairo(
                      text: status ?? '',
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
                      text: getTwoPartName(name),
                      color: primary_blue,
                      fontsize: 13,
                      fontweight: FontWeight.w700,
                    ),
                    TextCairo(
                      text: faculty ?? '',
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
                backgroundImage: NetworkImage(
                  'https://s3-alpha-sig.figma.com/img/fc8e/8722/3d89c4f6964dd191b6eccf24c31b6620?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=Ashj48mbbmqvoaNVPGCuGRu~kQWQuszCOTY7xhCo4hb6-keMI-yTX~~uYMkM2HCiVaP~pYY1855rEyS6RXEt3ejJKlopYSCgBknkdNlhodHmio2KSFOqFQQEKUa4RGlw2~x3DyLPQa8FFytHLhIXi-mT-f0vhvmBfTlgDOVp7gLHHqYaL-l5aaCMakOdxpVmmwloPs-NMml9Jn6B7D4NcTszXMQuZ2x9CaqMppjlM9cf92vV518-rZjQ7H1XmDitfHVNKbHxDBG60VllCh0XsO-tksr3jiLND4UOKYq8btuPXbyBB7RYh4wsAn79rCKMWjczid7sffoNKzLkK8mn1g__',
                ),
                radius: 18,
              ),
            ],
          ),
        ),
        // Image
        if (attachments != null)
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 10.0),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(attachments ?? ''),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        // Description
        if (attachments == null) SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextCairo(
            text: description ?? '',
            color: Colors.black,
            fontsize: 12,
            fontweight: FontWeight.w400,
            textalign: TextAlign.right,
          ),
        ),
        if (attachments == null) SizedBox(height: 30),
      ],
    ),
  );
}
