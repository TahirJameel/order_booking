import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Customer List/CustomerList.dart';
import 'Screens/New Order/NewOrder.dart';
import 'Screens/Product List/ProductList.dart';
import 'Screens/Save Data/SaveData.dart';
import 'Screens/Upload Data/UploadData.dart';
import 'about.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    initial();
  }

  // Customer List Method
  List<dynamic> userdata = [];
  List<dynamic> filteredUserData = [];

  Future<void> CustomerRecords() async {
    String uri = "http://isofttouch.com/eorder/view_data.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        userdata = jsonDecode(response.body);
        CustomerData(userdata);
        filteredUserData = List.from(userdata);
        print('userdata: $userdata');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> CustomerData(List<dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(data);
    await prefs.setString('userdata', jsonData);
  }

  Future<void> CustomerLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('userdata') ?? '[]';
    setState(() {
      userdata = jsonDecode(jsonData);
      filteredUserData = List.from(userdata);
    });
  }

  // Product List Method
  List<dynamic> Products = [];
  List<dynamic> UserData = [];

  Future<void> ProductRecords() async {
    String uri = "http://isofttouch.com/eorder/product.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        Products = jsonDecode(response.body);
        ProductData(Products);
        UserData = List.from(Products);
        print('Products: $Products');
      });
    } catch (e) {}
  }

  Future<void> ProductData(List<dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(data);
    await prefs.setString('Products', jsonData);
  }

  Future<void> ProductLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('Products') ?? '[]';
    setState(() {
      Products = jsonDecode(jsonData);
      UserData = List.from(Products);
    });
  }

  // LogOut Method
  late SharedPreferences logindata;
  late String ready;

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    String? data = logindata.getString('data');
    setState(() {
      ready = data ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Dashboard',
          style: GoogleFonts.dancingScript(
              color: const Color(0xff4a5759),
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          // Refresh Data Button widget
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CupertinoButton(
              color: const Color(0xffe8e8e4),
              padding: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(5),
              child: Column(
                children: [
                  Image.asset('assets/icons/refresh.png', scale: 16),
                  const Text(
                    'Refresh',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Refresh Database',
                  content:
                      const Text('Do you really want to Refresh Database.'),
                  buttonColor: Colors.black54,
                  textCancel: 'Cancel',
                  textConfirm: 'Confirm',
                  onConfirm: () async {
                    Navigator.pop(context);
                    CustomerRecords();
                    ProductRecords();
                    CustomerLoad();
                    ProductLoad();
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 10),

          // About page Button widget
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CupertinoButton(
              padding: const EdgeInsets.all(5),
              color: const Color(0xffe8e8e4),
              borderRadius: BorderRadius.circular(5),
              child: Column(
                children: [
                  Image.asset('assets/icons/about.png', scale: 16),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {
                Get.to(const About());
              },
            ),
          ),
          const SizedBox(width: 10),

          // Logout Button widget
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CupertinoButton(
              color: const Color(0xffe8e8e4),
              padding: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(5),
              child: Column(
                children: [
                  Image.asset('assets/icons/logout.png', scale: 16),
                  const Text(
                    'Logout',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {
                // Set the isLoggedIn flag to false
                logindata.setBool('isLoggedIn', false);

                Get.offAll(const Login());
              },
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Column(
          children: [
            // Company name and address container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffe8e8e4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company Full Name',
                    style: GoogleFonts.exo(
                        color: const Color(0xff495057),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Company Full Address',
                    style: GoogleFonts.exo2(
                        color: const Color(0xff495057),
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),

            // Dashboard GridView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.90,
                  children: [
                    CategoryCard(
                      pngSrc: 'assets/icons/neworder.png',
                      title: "New Order",
                      press: () {
                        Get.to(const NewOrder(
                          customerName: '',
                          Code: '',
                          orderData: [],
                          recordId: 0,
                          isedit: false,
                        ));
                      },
                    ),
                    CategoryCard(
                      pngSrc: 'assets/icons/save_data.png',
                      title: "Save Data",
                      press: () {
                        Get.to(const SaveData());
                      },
                    ),
                    CategoryCard(
                      pngSrc: 'assets/icons/customer_list.png',
                      title: "Customer List",
                      press: () {
                        Get.to(const CustomerList());
                      },
                    ),
                    CategoryCard(
                      pngSrc: 'assets/icons/productlist.png',
                      title: "Products List",
                      press: () {
                        Get.to(const ProductList());
                      },
                    ),
                    CategoryCard(
                      pngSrc: 'assets/icons/upload_data.png',
                      title: "Upload Data",
                      press: () {
                        Get.to(const UploadData());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String pngSrc;
  final String title;
  final VoidCallback press;

  const CategoryCard({
    super.key,
    required this.pngSrc,
    required this.title,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffe8e8e4),
      ),
      child: InkWell(
        onTap: press,
        child: Column(
          children: [
            const Spacer(),
            Image.asset(pngSrc, scale: 4.5),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
