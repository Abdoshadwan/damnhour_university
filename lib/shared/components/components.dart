import 'package:damnhour_university/shared/constants/constants.dart';
import 'package:damnhour_university/shared/cubit/cubit.dart';
import 'package:damnhour_university/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../admin/modules/AdminHome/AdminHome.dart';
import '../../models/home_model.dart';

Widget TextCairo({
  required String text,
  Color color = Colors.white,
  double fontsize = 16,
  FontWeight fontweight = FontWeight.w600,
  TextAlign? textalign,
  TextOverflow? Overflow,
  double? heightoftext,
}) {
  return Text(
    overflow: Overflow,
    textAlign: textalign,
    "${text}",
    style: TextStyle(
      height: heightoftext,
      fontFamily: 'Cairo',
      color: color,
      fontSize: fontsize,
      fontWeight: fontweight,
    ),
  );
}

Widget Button({
  required String text,
  required VoidCallback onpressed,
  Color color = const Color.fromRGBO(0, 9, 69, 1),
  Color textcolor = Colors.white,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(8),
      color: color,
    ),
    height: 52,
    width: 327 / 375 * ScreenSize.width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onpressed,
      child: TextCairo(text: text, color: textcolor),
    ),
  );
}

Widget CustomTextFeild({
  Widget? suffixicon,
  Widget? prefixicon,
  required String toptext,
  String? hinttext,
  TextEditingController? controller,
  TextInputType? inputType,
  bool enabled = true,
  bool obscureText = false,
  Color? bordercolor,
  String? Function(String?)? Validator,
  Function(String)? onchanged,
  TextInputType? keyboardtype,
}) {
  return Container(
    padding: EdgeInsets.all(8),
    width: 327 / 375 * ScreenSize.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextCairo(text: toptext, color: primary_blue, fontsize: 14),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: enabled == true ? Colors.white : disabled100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  bordercolor ??
                  (enabled == true
                      ? Color.fromRGBO(160, 169, 183, 1)
                      : disabled200),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              keyboardType: keyboardtype,
              onChanged: onchanged,
              validator: Validator,
              controller: controller,
              enabled: enabled,

              style: TextStyle(
                fontFamily: 'Cairo',
                color: enabled == true ? brandColor200 : disabled200,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
              obscureText: obscureText,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                suffixIcon: suffixicon,
                hintText: hinttext,
                hintStyle: TextStyle(color: Color.fromRGBO(89, 105, 130, 1)),
                prefixIcon: prefixicon,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget sharedSectors({
  required int index,
  context,
  required Function(String sectorName) onTap,
}) {
  List<String> sectors = [
    'الكل',
    'قطاع شئون التعليم والطلاب',
    'قطاع شئون خدمة المجتمع وتنمية البيئة',
    'قطاع الدراسات العليا',
    'قطاع امين عام الجامعه',
    'قطاع ادارة الجامعه',
  ];
  return Container(
    padding: EdgeInsetsDirectional.symmetric(horizontal: 11.0, vertical: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: primary_blue),
      color:
          UniversityCubit.get(context).sectorIndex == index
              ? primary_blue
              : Colors.white,
    ),
    child: InkWell(
      onTap: () {
        UniversityCubit.get(context).changeSectorIndex(index);
        onTap(sectors[index]);

        // UniversityCubit.get(context).filterPostsBySector(sectors[index]);
      },
      child: TextCairo(
        text: sectors[index],
        color:
            UniversityCubit.get(context).sectorIndex == index
                ? Colors.white
                : primary_blue,
      ),
    ),
  );
}

Widget sectorsListView({required Function(String) onTap}) => Container(
  height: 36.0,
  child: ListView.separated(
    physics: BouncingScrollPhysics(),
    scrollDirection: Axis.horizontal,
    reverse: true,
    itemBuilder:
        (context, index) =>
            sharedSectors(index: index, context: context, onTap: onTap),
    separatorBuilder: (context, index) => SizedBox(width: 10.0),
    itemCount: 6,
  ),
);

void navigateTo({required Widget to, required context}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => to));
}

Widget richTextCairoSteps() {
  return RichText(
    textDirection: TextDirection.rtl,
    text: TextSpan(
      style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Cairo'),
      children: [
        TextSpan(text: '1. '),
        TextSpan(
          text: 'تسجيل الدخول\n',
          style: TextStyle(
            color: primary_blue,
            fontFamily: 'Cairo',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: 'باستخدام بياناتك الجامعية\n',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Cairo',
            fontSize: 14.0,
          ),
        ),

        TextSpan(text: '2. '),
        TextSpan(
          text: 'اختيار نوع الشكوى\n',
          style: TextStyle(
            color: primary_blue,
            fontFamily: 'Cairo',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: 'من القائمة المتاحة\n',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Cairo',
            fontSize: 14.0,
          ),
        ),

        TextSpan(text: '3. '),
        TextSpan(
          text: 'كتابة تفاصيل الشكوى\n',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: primary_blue,
            fontFamily: 'Cairo',
            fontSize: 16.0,
          ),
        ),
        TextSpan(
          text: 'وإضافة مرفقات إن وجدت\n',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Cairo',
            fontSize: 14.0,
          ),
        ),

        TextSpan(text: '4. '),
        TextSpan(
          text: 'إرسال الشكوى\n',
          style: TextStyle(
            color: primary_blue,
            fontFamily: 'Cairo',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: 'للجهة المختصة\n',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Cairo',
            fontSize: 14.0,
          ),
        ),

        TextSpan(text: '5. '),
        TextSpan(
          text: 'متابعة حالة الشكوى\n',
          style: TextStyle(
            color: primary_blue,
            fontFamily: 'Cairo',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: 'من خلال سجل الشكاوى',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Cairo',
            fontSize: 14.0,
          ),
        ),
      ],
    ),
  );
}

Widget supportRichTextCairo() {
  return RichText(
    textDirection: TextDirection.rtl,
    text: TextSpan(
      style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Cairo'),
      children: [
        TextSpan(
          text: 'إذا واجهت أي مشكلة في استخدام التطبيق، يرجى التواصل معنا:\n',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
        TextSpan(
          text: 'البريد الإلكتروني: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: brandColor300,
          ),
        ),
        TextSpan(
          text: 'support@universitycomplaints.edu\n',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        TextSpan(
          text: 'رقم واتساب: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: brandColor300,
          ),
        ),
        TextSpan(
          text: '012111111111\n',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),

        TextSpan(
          text: 'ساعات العمل: من 9 ص إلى 5 م (أيام العمل الرسمية)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: brandColor300,
          ),
        ),
      ],
    ),
  );
}

Widget dropdownlist({
  required String? selectedvalue,
  String? title,
  required String hinttext,
  required List<String> dropdownitems,
  required Function(String?) onchanged,
  IconData? dropIcon,
  Color? bordercolor,
  double? width,
  bool enabled = true,
}) => Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    if (title != null)
      TextCairo(text: title, color: primary_blue, fontsize: 14),
    if (title != null) SizedBox(height: 8),
    Container(
      width: width ?? 327 / 375 * ScreenSize.width - 10,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : disabled100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: bordercolor ?? (enabled ? brandColor25 : disabled200),
        ),
      ),
      child: AbsorbPointer(
        absorbing: !enabled,
        child: DropdownButtonFormField<String>(
          value: selectedvalue,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: Icon(dropIcon),
          ),
          hint: Align(
            alignment: Alignment.centerRight,
            child: Text(
              hinttext,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: const Color.fromRGBO(89, 105, 130, 1),
              ),
            ),
          ),
          items:
              dropdownitems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: enabled ? brandColor200 : disabled200,
                      ),
                    ),
                  ),
                );
              }).toList(),
          onChanged: onchanged,
          isExpanded: true,
          alignment: Alignment.centerRight,
        ),
      ),
    ),
  ],
);

Future<bool?> showtoast({required String message, required Color color}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16,
  );
}

void navigatet_close({required context, required Widget to}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => to),
      (route) => false,
    );

Widget buildPostItem(context, ItemModel model) {
  var cubit = UniversityCubit.get(context);
  return Padding(
    padding: EdgeInsetsDirectional.symmetric(
      horizontal: ScreenSize.width * 0.04,
    ),
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
                  Flexible(
                    child: statusof(
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
                  ),
                  Column(
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
                          SizedBox(width: 8.0),
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
                ],
              ),
            ),
            SizedBox(width: 15.0),
            InkWell(
              onTap: () {
                UniversityCubit.get(context).changeBottomNav(0);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(model.user!.profile_image!),
                radius: 25.0,
              ),
              // Container(
              //   width: ScreenSize.width * 0.14,
              //   height: ScreenSize.width * 0.14,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     image: DecorationImage(
              //       image:
              //           model.user!.profile_image! , //model.user.profile_image
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
        // Container(
        //   padding: EdgeInsetsDirectional.symmetric(
        //     horizontal: ScreenSize.width * 0.05,
        //   ),
        //   width: double.infinity,
        //   height: ScreenSize.height * 0.06,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(8.0),
        //     border: Border.all(color: neutralColor25),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Expanded(
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             SizedBox(width: ScreenSize.width * 0.02),
        //             TextCairo(
        //               text: '${model.dislike_count}',
        //               color: Colors.black,
        //             ),
        //             Container(
        //               width: ScreenSize.width * 0.15,
        //               height: ScreenSize.height * 0.045,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(8.0),
        //               ),
        //               child: IconButton(
        //                 onPressed: () {
        //                   cubit.changedislike(model);
        //                   cubit.updateLikeDislike(
        //                     id: model.id,
        //                     isLike: false,
        //                     type_S_C: model.sc_type,
        //                     newCount: model.dislike_count ?? 0 + 1,
        //                   );
        //                 },
        //                 icon: Icon(
        //                   Icons.thumb_down_alt_outlined,
        //                   color:
        //                       model.isdislike == true
        //                           ? Colors.red
        //                           : Colors.black,
        //                 ),
        //               ),
        //             ),
        //             SizedBox(width: ScreenSize.width * 0.02),
        //             TextCairo(text: '${model.like_count}', color: Colors.black),
        //             Container(
        //               width: ScreenSize.width * 0.15,
        //               height: ScreenSize.height * 0.045,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(8.0),
        //                 color: Colors.white,
        //               ),
        //               child: IconButton(
        //                 onPressed: () {
        //                   cubit.changelike(model);
        //                   cubit.updateLikeDislike(
        //                     id: model.id,
        //                     isLike: true,
        //                     type_S_C: model.sc_type,
        //                     newCount: model.like_count ?? 0 + 1,
        //                   );
        //                 },
        //                 icon: Icon(
        //                   Icons.thumb_up_alt_outlined,
        //                   color:
        //                       model.islike == true
        //                           ? Colors.green
        //                           : Colors.black,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Padding(
        //         padding: EdgeInsetsDirectional.only(
        //           end: ScreenSize.width * 0.05,
        //         ),
        //         child: TextCairo(
        //           text: 'هل هذه الشكوى حقيقية ؟',
        //           fontsize: 13.0,
        //           fontweight: FontWeight.w400,
        //           color: primary_blue,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    ),
  );
}

/////////////////////////////////////////////////STATUS OF COMPLAINTS///////////////////////////////////////////////////
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
