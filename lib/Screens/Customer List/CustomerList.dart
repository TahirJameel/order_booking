import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<dynamic> userdata = [];
  List<dynamic> filteredUserData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRecords();
    loadData();
  }

  Future<void> getRecords() async {
    String uri = "http://isofttouch.com/eorder/view_data.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        userdata = jsonDecode(response.body);
        saveData(userdata);
        filteredUserData = List.from(userdata);
        print('userdata: $userdata');
      });
    } catch (e) {
      print(e);
    }
  }

  void filterData(String id) {
    setState(() {
      filteredUserData = userdata
          .where((user) =>
              user['cid'].toString().contains(id.toLowerCase()) ||
              user['cname'].toString().toLowerCase().contains(id.toLowerCase()))
          .toList();
    });
  }

  Future<void> saveData(List<dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(data);
    await prefs.setString('userdata', jsonData);
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('userdata') ?? '[]';
    setState(() {
      userdata = jsonDecode(jsonData);
      filteredUserData = List.from(userdata);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
          child: Column(
            children: [
              Row(
                children: [
                  CupertinoButton(
                    color: const Color(0xff4a5759),
                    padding: EdgeInsets.zero,
                    child:
                        const Icon(Iconsax.arrow_left_1, color: Colors.white),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CupertinoTextField(
                      controller: searchController,
                      padding: const EdgeInsets.all(10),
                      placeholder: 'Search Customers',
                      placeholderStyle: const TextStyle(
                          color: CupertinoColors.placeholderText),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Iconsax.search_normal,
                            color: Color(0xff4a5759)),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xff4a5759),
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      onChanged: (value) {
                        filterData(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUserData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Text(
                          filteredUserData[index]['cid'],
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        title: Text(
                          filteredUserData[index]['cname'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(filteredUserData[index]['address1']),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
