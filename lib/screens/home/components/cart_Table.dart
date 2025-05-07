import 'package:flutter/material.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/home/components/cart_Details.dart';
import 'package:animation_2/screens/home/components/footer.dart';
import 'package:animation_2/api_services.dart';

import 'cart_order_list.dart';

class CartTable extends StatefulWidget {
  const CartTable({Key? key, required this.controller}) : super(key: key);

  final HomeController controller;

  @override
  _CartTableState createState() => _CartTableState();
}

class _CartTableState extends State<CartTable> {
  late Future<List<Order>> futureOrdersList;

  @override
  void initState() {
    super.initState();
    futureOrdersList = ApiService().fetchOrdersList();
  }

  Future<void> _refreshPage() async {
    setState(() {
      futureOrdersList = ApiService().fetchOrdersList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xFFE4F0E6),
        ),
        backgroundColor: Color(0xFFE4F0E6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "โต๊ะ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: FutureBuilder<List<Order>>(
          future: futureOrdersList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('ไม่มีรายการชำระเงิน', style: TextStyle(fontSize: 18, color: Colors.black54),),);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found'));
            } else {
              List<Order> orders = snapshot.data!;
              return Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 100,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    dataTextStyle: TextStyle(
                      fontSize: 14,
                    ),
                    columns: [
                      DataColumn(
                        label: Text('หมายเลขโต๊ะ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      // เพิ่มคอลัมน์ใหม่สำหรับปุ่ม "รายละเอียด"
                      DataColumn(
                        label: Text(
                          'รายละเอียด',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                    rows: orders
                        .map((order) => DataRow(cells: [
                      DataCell(
                        Center(
                          child: Text(
                            order.table.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartDetails(
                                order: order,
                                controller: widget.controller,
                              ),
                            ),
                          );
                        },
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartDetails(
                                  order: order,
                                  controller: widget.controller,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade300, // สีของปุ่ม
                          ),
                          child: Text(
                            'รายละเอียด',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ]))
                        .toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Color(0xFFEAEAEA),
        child: Footer(controller: widget.controller),
      ),
    );
  }
}
