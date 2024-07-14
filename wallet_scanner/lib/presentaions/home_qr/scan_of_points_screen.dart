import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:wallet_scanner/presentaions/home_qr/scan_of_wallet_screen.dart';

class PointsScreen extends StatefulWidget {
  PointsScreen({super.key, required this.id});
  String id;
  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  TextEditingController passowrdController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: Positioned(
            right: 0,
            left: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 80.h,
                width: double.infinity,
                // color: MyColors.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w).h,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 35.h,
                        width: 36.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: Color.fromRGBO(255, 99, 25, 1))),
                        child: Center(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 7, left: 7).w,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color.fromRGBO(255, 99, 25, 1),
                                  size: 24,
                                ))),
                      )),
                ),
              ),
            ),
          ),
          title: Text(
            "النقاط",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100.h,
              ),
              Text(
                'ادخل البريد الالكتروني',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              TextFormFiled(
                readOnly: false,
                maxLines: 1,
                minLines: 1,
                textInputType: TextInputType.emailAddress,
                obscureText: false,
                controller: passowrdController,
                hintText: 'البريد الالكتروني',
                validator: () {},
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (passowrdController.text.isNotEmpty) {
                    setState(() {
                      scanToGetPoints(sendData: {
                        'code': widget.id,
                        'email': passowrdController.text,
                      });

                      loading = true;
                    });
                  } else {
                    ShowToast(
                        msg: 'ادخل البريد الالكتروني',
                        states: ToastStates.ERROR);
                  }
                },
                child: Container(
                  height: 50.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Color.fromRGBO(255, 99, 25, 1)),
                  child: Center(
                    child: loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'ارسال',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanToGetPoints({Map<String, dynamic>? sendData}) async {
     var data = FormData.fromMap(
        sendData!);
    await DioHelper.dio
        .post(
            'https://admin.gulfsaudi.com/public/api/v1/client/ScanToGetPoints',
            data: data)
        .then((value) {
      setState(() {
        loading = false;
      });

        ShowToast(
          msg: value.data["status"] == true
              ? 'تمت العمليه بنجاح'
              : value.data['message']["code"] != null
                  ? "The selected code is invalid."
                  : value.data['message']["email"] != null
                      ? "The selected email is invalid."
                     
                          : '',
          states: value.data["status"] == true
              ? ToastStates.SUCCESS
              : ToastStates.ERROR);

      print('${value.data['message']['email'][0].toString()}=============');
    }).catchError((onError) {
      print('${onError}');
    });
  }
}
