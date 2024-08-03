import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet_scanner/dio_helper.dart';
import 'package:wallet_scanner/main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<LoginScreen> {
  TextEditingController passowrdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  var ispassword = true;
  IconData suffix = Icons.visibility_outlined;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Form(
                // key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 89.h,
                    ),
                    Container(
                      height: 80.h,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/gulf-logo-.png'),
                      )),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(14.w),
                        child: TextUtils(
                          fontSize: 30.sp,
                          color: Color.fromRGBO(36, 31, 31, 1),
                          text: "Login",
                          fontWeight: FontWeight.w700,
                          underLine: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 12.w),
                      child: TextFormFiled(
                        readOnly: false,
                        maxLines: 1,
                        minLines: 1,
                        textInputType: TextInputType.emailAddress,
                        obscureText: false,
                        controller: emailController,
                        hintText: 'email',
                        validator: () {},
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    AppColumnPassWord(
                      controllar: passowrdController,
                      textInputType: TextInputType.visiblePassword,
                      hintText: "password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              changePsswordVisibility();
                            });
                          },
                          icon: Icon(
                            suffix,
                            color: Color(0xff636363),
                          )),
                      obscureText: ispassword,
                      textformfieldName: "password",
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w)
                              .w,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (emailController.text.isNotEmpty &&
                                passowrdController.text.isNotEmpty) {
                              userLogin(
                                  email: emailController.text,
                                  password: passowrdController.text,
                                  context: context);
                            } else {
                              AwesomeDialog(
                                btnOkText: 'ok',
                                context: context,
                                dialogType: DialogType.noHeader,
                                btnOkColor: Color.fromRGBO(255, 99, 25, 1),
                                buttonsTextStyle: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                                animType: AnimType.rightSlide,
                                title: 'All Fileds Required',
                                desc: 'Please Fill All Fileds',
                                btnOkOnPress: () {},
                              ).show();
                            }
                          });
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
                                : TextUtils(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    text: "Login",
                                    fontWeight: FontWeight.bold,
                                    underLine: TextDecoration.none,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  Future<void> userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    var data =
        FormData.fromMap({'email': email, 'password': password, 'type': '1'});
    setState(() async {
      loading = true;
      var dio = Dio();
      var response = await dio.request(
        'https://admin.gulfsaudi.com/public/api/v1/guest/login',
        options: Options(
          method: 'POST',
        ),
        data: data,
      );

      if (response.data != null && response.data['status'] == true && response.data[ "data"][ "type"]== "مخصم") {
      setState(() {
          loading = false;
      });
    CasheHelper.saveData(key: 'token', value: response.data[ "token"]);
      CasheHelper.getToken();
        AwesomeDialog(
          dismissOnTouchOutside: false,
          btnOkText: 'Enter',
          context: context,
          dialogType: DialogType.noHeader,
          btnOkColor: Color.fromRGBO(255, 99, 25, 1),
          buttonsTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          animType: AnimType.rightSlide,
          title: 'Login successfully',
          desc: 'Welcome',
          btnOkOnPress: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: ((context) => HomeScreen())),
                (route) => false);
          },
        ).show();
        loading = false;
      } else {
        AwesomeDialog(
          dismissOnTouchOutside: false,
          btnOkText: 'ok',
          context: context,
          dialogType: DialogType.noHeader,
          btnOkColor: Color.fromRGBO(255, 99, 25, 1),
          buttonsTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          animType: AnimType.rightSlide,
          title: '${response.data['message']}',
          desc: 'Please try again',
          btnOkOnPress: () {},
        ).show();
           setState(() {
          loading = false;
      });
      }
    });
  }

  void changePsswordVisibility() {
    setState(() {
      ispassword = !ispassword;
      suffix = ispassword
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined;
    });
  }
}

class TextUtils extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration? underLine;
  final TextAlign? textAlign;
  const TextUtils({
    required this.fontSize,
    required this.fontWeight,
    required this.text,
    required this.color,
    this.underLine,
    Key? key,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      softWrap: true,
      style: TextStyle(
        decoration: underLine,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

class AppColumnPassWord extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  AppColumnPassWord(
      {required this.controllar,
      required this.textformfieldName,
      required this.textInputType,
      required this.hintText,
      required this.suffixIcon,
      this.widget,
      required this.obscureText});
  TextEditingController controllar;
  TextInputType textInputType;
  String textformfieldName;
  String hintText;
  Widget suffixIcon;
  bool obscureText;
  Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12).w,
          child: Row(
            children: [
              TextUtils(
                color: Color.fromRGBO(36, 31, 31, 1),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                text: textformfieldName,
                underLine: TextDecoration.none,
              ),
              widget ?? Container(),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Padding(
            padding:
                const EdgeInsets.only(bottom: 2, left: 12, right: 12, top: 8).r,
            child: PassWordWidget(
                controller: controllar,
                textInputType: textInputType,
                hintText: hintText,
                suffixIcon: suffixIcon,
                obscureText: obscureText)),
      ],
    );
  }
}

class PassWordWidget extends StatelessWidget {
  PassWordWidget(
      {super.key,
      required this.controller,
      required this.textInputType,
      required this.hintText,
      required this.suffixIcon,
      required this.obscureText});

  final TextEditingController controller;
  final TextInputType textInputType;
  Widget suffixIcon;
  final String hintText;
  bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Color.fromRGBO(255, 99, 25, 1),
      keyboardType: textInputType,
      validator: (value) {
        if (value!.isEmpty) {
          return '${hintText} يجب الا يكون فارغا ';
        }
        return null;
      },
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 10.h),
        filled: true,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black45,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: Color.fromRGBO(255, 99, 25, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: Color.fromRGBO(255, 99, 25, 1)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
