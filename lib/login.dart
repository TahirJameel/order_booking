import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();

  late SharedPreferences logindata;
  late bool ready;
  Future<void> saveData(String userid, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', userid);
    prefs.setString('password', password);
    prefs.setBool('isLoggedIn', true);
  }

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  // password toggle
  bool passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    Future login() async {
      try {
        var url = Uri.parse("http://isofttouch.com/eorder/login1.php?loginid=${userid.text}&pascode=${password.text}");
        var response = await http.get(url);
        var data = json.decode(response.body);

        if (data == "Success") {
          Get.snackbar('Login', 'Successful');

          // Save user data to shared preferences
          saveData(userid.text, password.text);

          // Set the isLoginIn flag to true
          logindata.setBool('isLoggedIn', true);

          Get.offAll(const Dashboard());
        } else {
          Get.snackbar('Incorrect', 'Userid Or Password');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
              Center(child: Text('please check your internet connection')),
              backgroundColor: Colors.blueGrey),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/loginpic.png', scale: 2),
                const SizedBox(height: 30),
                Text(
                  'Login to your Account',
                  style: GoogleFonts.dancingScript(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Login Form
                Form(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Id Text Field
                        const Text(
                          'User ID',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 5),
                        CupertinoTextField(
                          controller: userid,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          padding: const EdgeInsets.all(17),
                          placeholder: 'User id',
                          placeholderStyle:
                          const TextStyle(color: Colors.black45),
                          prefix: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Iconsax.user_edit,
                                color: Color(0xff4a5759)),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: CupertinoColors.placeholderText,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Text Field
                        const Text(
                          'Password',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 5),
                        CupertinoTextField(
                          controller: password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordObscured,
                          textInputAction: TextInputAction.next,
                          padding: const EdgeInsets.all(17),
                          placeholder: 'Password',
                          placeholderStyle:
                          const TextStyle(color: Colors.black45),
                          prefix: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Iconsax.password_check,
                                color: Color(0xff4a5759)),
                          ),
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordObscured = !passwordObscured;
                                });
                              },
                              icon: Icon(
                                passwordObscured
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                color: const Color(0xff4a5759),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: CupertinoColors.placeholderText,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),


                        // const SizedBox(height: 20),
                        //
                        // // Company Id TextField
                        // const Text(
                        //   'Company ID',
                        //   style: TextStyle(
                        //       color: Colors.black38,
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w400),
                        // ),
                        // const SizedBox(height: 5),
                        // CupertinoTextField(
                        //   keyboardType: TextInputType.name,
                        //   padding: const EdgeInsets.all(17),
                        //   placeholder: 'Company ID',
                        //   placeholderStyle:
                        //   const TextStyle(color: Colors.black45),
                        //   prefix: const Padding(
                        //     padding: EdgeInsets.only(left: 10),
                        //     child: Icon(Iconsax.direct_right,
                        //         color: Color(0xff4a5759)),
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     border: Border.all(
                        //       color: CupertinoColors.placeholderText,
                        //     ),
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
                        const SizedBox(height: 50),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            color: const Color(0xff4a5759),
                            borderRadius: BorderRadius.circular(10),
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            onPressed: () {
                              login();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    bool isLoggedIn = logindata.getBool('isLoggedIn') ?? false;

    print(isLoggedIn);
    if (isLoggedIn) {
      // User is logged in, navigate to the dashboard screen
      Get.offAll(const Dashboard());
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  @override
  void dispose() {
    userid.dispose();
    password.dispose();
    super.dispose();
  }
}
