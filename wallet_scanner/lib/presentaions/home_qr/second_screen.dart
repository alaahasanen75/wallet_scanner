import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_scanner/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen({super.key, required this.id});
  String id;
  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TextEditingController moneyController = TextEditingController();
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
            "ارسال رصيد",
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
                'ادخل المبلغ الذي تريد ارساله',
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
                textInputType: TextInputType.number,
                obscureText: false,
                controller: moneyController,
                hintText: '250' + ' ' + 'SR',
                validator: () {},
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'ادخل كلمة السر',
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
                textInputType: TextInputType.text,
                obscureText: true,
                controller: passowrdController,
                hintText: '********',
                validator: () {},
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                onTap: () {
                  if (passowrdController.text.isNotEmpty &&
                      moneyController.text.isNotEmpty) {
                    setState(() {
                      loading = true;
                      scanToGetUserId(
                          id: widget.id,
                          amount: moneyController.text,
                          password: passowrdController.text);
                    });
                  } else {
                    ShowToast(
                        msg: 'ادخل المبلغ وكلمه السر',
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

  Future<void> scanToGetUserId({required String id, amount, password}) async {
    var data = FormData.fromMap(
        {'client_id': id, 'amount': amount, 'password': password});
    await DioHelper.dio
        .post(
            'https://admin.gulfsaudi.com/public/api/v1/client/scanToPayToStationFromWallet',
            data: data)
        .then((value) {
      setState(() { loading = false;});

          ShowToast(
                        msg: value.data['message'].toString(),
                        states:
                        
                        value.data['message'].toString()== "عملية التحويل تمت بنجاح"?
                        
                        
                         ToastStates.SUCCESS:ToastStates.ERROR);
      print('${value.data['message'].toString()}=============');
    }).catchError((onError) {
      setState(() { loading = false;});
           ShowToast(
                        msg:onError,
                        states:
                        
                        
                        
                         ToastStates.ERROR);
      print('${onError}');
    });
  }
}

void ShowToast({required String? msg, required ToastStates? states}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: ChooseToastColor(states!),
      textColor: Colors.black,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color? ChooseToastColor(ToastStates states) {
  Color color;

  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
