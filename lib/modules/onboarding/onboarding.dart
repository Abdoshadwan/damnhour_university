import 'package:damnhour_university/modules/register/register.dart';
import 'package:damnhour_university/shared/components/components.dart';
import 'package:damnhour_university/shared/constants/constants.dart';
import 'package:damnhour_university/shared/styles/colors.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primary_blue,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          child: TextCairo(
                            text: "نظام إدارة الشكاوي و المقترحات",
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(child: TextCairo(text: "بجامعة دمنهور")),
                      ],
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 100,
                      child: Image(image: AssetImage("assets/images/logo.png")),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: ScreenSize.width - 48,
                    height: .7 * ScreenSize.height + 20,
                    decoration: BoxDecoration(
                      color: brand,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    width: ScreenSize.width,
                    height: .7 * ScreenSize.height,

                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          TextCairo(
                            text: 'هل واجهت مشكلة في جامعتك؟',
                            color: primary_blue,
                          ),
                          SizedBox(height: 40),
                          Container(
                            width: 200 / 375 * ScreenSize.width,
                            height: 209 / 582 * .7 * ScreenSize.height,

                            child: Image(
                              image: AssetImage("assets/images/onboard.png"),
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
                            width: 327 / 375 * ScreenSize.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextCairo(
                                  text:
                                      'لا تدعها تمر بصمت! أبلغ عنها بسهولة، وكن',
                                  color: accent_orange,
                                  fontsize: 18,
                                ),
                                TextCairo(
                                  text: '.جزءًا من الحل',
                                  color: accent_orange,
                                  fontsize: 18,
                                ),
                                SizedBox(height: 10),
                                TextCairo(
                                  text:
                                      '!التغيير يبدأ بك، فلا تتردد في اتخاذ الخطوة الأولى',
                                  color: primary_blue,
                                  fontsize: 12,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          Button(
                            onpressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ),
                              );
                            },
                            text: 'ابدأ الان',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
