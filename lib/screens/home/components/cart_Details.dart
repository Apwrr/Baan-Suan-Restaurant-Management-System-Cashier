import 'package:animation_2/screens/home/components/Receipt.dart';
import 'package:animation_2/screens/home/components/ReceiptPage.dart';
import 'package:animation_2/screens/home/components/cart_order_list.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/home/components/Footer.dart';
import 'package:animation_2/screens/home/components/cart_Table.dart';

class CartDetails extends StatefulWidget {
  final Order order;
  final HomeController controller;

  const CartDetails({
    Key? key,
    required this.order,
    required this.controller,
  }) : super(key: key);

  @override
  _CartDetailsState createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  bool isOrderAccepted = false;
  List<Receipt> receipts = [];

  double _calculateTotalPrice(List<OrderItem> orderItems) {
    double totalPrice = 0;
    for (var item in orderItems) {
      totalPrice += item.qty * item.price;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice(widget.order.orderItems);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFE4F0E6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'รายละเอียดโต๊ะ ${widget.order.table}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              widget.order.orderItems.length,
                  (index) => ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(widget.order.orderItems[index].imagePath),
                ),
                title: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.order.orderItems[index].menuName,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${widget.order.orderItems[index].price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'X ${widget.order.orderItems[index].qty}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${(widget.order.orderItems[index].qty * widget.order.orderItems[index].price).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'รวมราคาทั้งหมด: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    totalPrice.toStringAsFixed(2),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('ยืนยันการชำระเงิน'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('ไม่ใช่'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    receipts = await widget.controller.submit(widget.order.id, widget.order.table);
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('ชำระเงินสำเร็จ')),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReceiptPage(receipts: receipts),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('การชำระเงินล้มเหลว')),
                                    );
                                  }
                                },
                                child: Text('ใช่'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text(
                      "ชำระเงิน",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            /*Container(
              padding: const EdgeInsets.all(16.0),
              color: Color(0xFFEAEAEA),
              child: Footer(controller: widget.controller),
            ),*/
          ],
        ),
      ),
    );
  }
}
