import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:x_order/Helper/database.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  @override
  void initState() {
    super.initState();
    fetchagain();
  }

  List<Map<String, dynamic>> savedData = [];

  List<Map<String, dynamic>> filteredData = [];

  Future<void> fetchagain() async {
    try {
      // Initialize the LocalDatabase
      LocalDatabase localDatabase = LocalDatabase();

      // Initialize the local database if not already initialized
      await localDatabase.initDatabase();

      // Retrieve the saved data from the local database
      var data = await localDatabase.readalldata();

      // Ensure data is not null
      savedData = data;
      filteredData = savedData
          .where((item) => item['upload'] == 'Yes')
          .toList(); // Filter data where upload is 'Yes'
      setState(() {});
    } catch (e) {
      print('Error fetching data from the database: $e');
      // Handle the error or notify the user accordingly.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Data',
          style: GoogleFonts.dancingScript(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                var item = filteredData[index];
                String orderDataString =
                    filteredData[index]['order_data']?.toString() ?? '';
                List<Map<String, dynamic>> orderData =
                    (jsonDecode(orderDataString) as List<dynamic>)
                        .cast<Map<String, dynamic>>()
                        .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Invoice Card Widget
                    Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                            leading: Text(
                              item['customerCode'],
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.red),
                            ),
                            title: Text(
                              item['customerName'],
                              style: const TextStyle(
                                color: Colors.teal,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              ...orderData.map((order) {
                                String itemName =
                                    order['item']?.toString() ?? 'N/A';
                                String quantity =
                                    order['quantity']?.toString() ?? 'N/A';

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          itemName,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          quantity,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.defaultDialog(
            title: 'Confirmation',
            content: const Text('Do you really want to delete the data.'),
            buttonColor: Colors.black54,
            textCancel: 'Cancel',
            textConfirm: 'Confirm',
            onConfirm: () {
              Navigator.of(context).pop(true);
            },
          );
        },
        elevation: 0,
        backgroundColor: const Color(0xff4a5759),
        label: const Text(
          'Delete Data',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
