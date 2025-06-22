import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/notification_model.dart';
import '../../shared/components/components.dart';
import '../../shared/constants/constants.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/colors.dart';
import 'package:intl/intl.dart';



class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = UniversityCubit.get(context);

    return BlocConsumer<UniversityCubit, UniversityStates>(
      listener: (context, state) {
        if (state is DeleteNotificationsSuccessState) {
          showtoast(message: 'تم حذف الإشعار بنجاح', color: Colors.green);
        }
      },
      builder: (context, state) {
        var cubit = UniversityCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextCairo(
                  text: 'الاشعارات',
                  fontsize: 18.0,
                  color: primary_blue,
                  textalign: TextAlign.end,
                ),
                SizedBox(width: ScreenSize.width * 0.02),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: ScreenSize.width * 0.05,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    print(token);
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(ScreenSize.width * 0.05),
            child: cubit.notificationsList.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/undraw_notify_rnwe 1.svg',
                    height: ScreenSize.height * 0.13,
                    width: ScreenSize.width * 0.33,
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  TextCairo(
                    text: 'لا إشعارات حالياً',
                    color: primary_blue,
                  ),
                  SizedBox(height: ScreenSize.height * 0.015),
                  TextCairo(
                    text: 'يبدو أن كل شيء يسير على ما يرام...',
                    fontsize: 12.0,
                    fontweight: FontWeight.w400,
                    color: accent_orange,
                  ),
                ],
              ),
            )
                : ListView.separated(
              itemBuilder: (context, index) {
                var model = cubit.notificationsList[index];
                return buildNotificationItem(
                  model,
                  key: ValueKey(model.id),
                  onDismissed: () {
                    cubit.deleteNotification(model.id!);
                  },
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: ScreenSize.height * 0.012),
              itemCount: cubit.notificationsList.length,
            ),
          ),
        );
      },
    );
  }

  Widget buildNotificationItem(
      NotificationModel model, {
        required VoidCallback onDismissed,
        required Key key,
      }) {
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismissed();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.width * 0.05),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextCairo(text: 'حذف', color: Colors.white, fontsize: 16),
            SizedBox(width: ScreenSize.width * 0.02),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        height: ScreenSize.height * 0.15,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(ScreenSize.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextCairo(
                      text: formatDateTime(model.created_at ?? ''),
                      color: Colors.grey,
                      fontsize: 12.0,
                    ),
                    SizedBox(width: ScreenSize.width * 0.02),
                    TextCairo(
                      text: model.title ?? '',
                      color: Colors.black,
                      fontweight: FontWeight.w700,
                      fontsize: 15.0,
                    ),
                    SizedBox(width: ScreenSize.width * 0.01),
                    Icon(Icons.notifications_none),
                  ],
                ),
                SizedBox(height: ScreenSize.height * 0.012),
                TextCairo(
                  text: model.message ?? '',
                  color: Colors.black,
                  textalign: TextAlign.end,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy - hh:mm a').format(dateTime);
  }
}
