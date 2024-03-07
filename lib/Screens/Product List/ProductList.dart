import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<dynamic> Products = [];
  List<dynamic> UserData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ProductLoad();
  }

  void filterData(String id) {
    setState(() {
      UserData = Products.where((user) =>
              user['cid'].toString().contains(id.toLowerCase()) ||
              user['cname'].toString().toLowerCase().contains(id.toLowerCase()))
          .toList();
    });
  }

  Future<void> ProductLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = prefs.getString('Products') ?? '[]';
    setState(() {
      Products = jsonDecode(jsonData);
      UserData = List.from(Products);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                      placeholder: 'Search Products',
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
                  itemCount: UserData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: ListTile(
                        leading: Text(
                          UserData[index]['cid'],
                          style:
                              const TextStyle(fontSize: 16, color: Colors.teal),
                        ),
                        title: Text(
                          UserData[index]['cname'],
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        ),
                        trailing: Text(UserData[index]['cost_price'],
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
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
