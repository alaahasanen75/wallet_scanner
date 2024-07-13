import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:wallet_scanner/presentaions/home_qr/second_screen.dart';

void main() {
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  String? massage;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(255, 99, 25, 1),
                centerTitle: true,
                title: const Text(
                  'Scanner',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              body: Builder(builder: (context) {
                return Material(
                  child: Center(
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: () {
                          _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                              context: context,
                              onCode: (code) {
                                setState(() {
                                  print('${code}==========');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SecondScreen(
                                            id: code!,
                                          )));
                                });
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                              height: 50.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromRGBO(255, 99, 25, 1),
                                    width: 1.w),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                  child: Text(
                                "Scan QR",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ))),
                        )),
                  ),
                );
              }),
            ),
          );
        });
  }
}
