import 'package:chico_ff/data/firebase_service/firebase_auth.dart';
import 'package:chico_ff/util/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chico_ff/util/exception.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final passwordConfirm = TextEditingController();
  FocusNode passwordConfirm_F = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 100.h, width: 96.w),
            // Center(
            //   child: CircleAvatar(
            //     radius: 32.r,
            //     backgroundColor: Colors.grey.shade200,
            //     // backgroundImage: AssetImage(''),
            //   ),
            // ),
            SizedBox(height: 120.h),
            Textfield(username, Icons.person, 'Username', username_F),
            SizedBox(height: 15.h),
            Textfield(email, Icons.email, 'Email', email_F),
            SizedBox(height: 15.h),
            Textfield(password, Icons.lock, 'Password', password_F),
            SizedBox(height: 15.h),
            Textfield(passwordConfirm, Icons.lock, 'Confirm Password',
                passwordConfirm_F),
            SizedBox(height: 15.h),
            Login(),
            SizedBox(height: 10.h),
            Have()
          ],
        ),
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Remembered your account? ",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Login() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          try{
            await Authentication().Signup(
              email: email.text,
              password: password.text,
              passwordConfirm: passwordConfirm.text,
              username: username.text,
            );
          } on exceptions catch (e) {
            dialogBuilder(context, e.message);
          }
        },
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 23.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }

  Widget Forgot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Text(
        'Forgot your password?',
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget Textfield(TextEditingController controller, IconData icon, String type,
      FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: type,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.grey, width: 2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.black, width: 2.w),
            ),
          ),
        ),
      ),
    );
  }
}
