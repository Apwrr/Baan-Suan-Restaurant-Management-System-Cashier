import 'package:flutter/material.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/home/components/Receipt.dart';
import 'package:animation_2/screens/home/components/cart_Table.dart';

class ReceiptPage extends StatelessWidget {
  final List<Receipt> receipts;

  const ReceiptPage({Key? key, required this.receipts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xFFE4F0E6
          ),
        ),
        backgroundColor: Color(0xFFE4F0E6),
        elevation: 0,
        centerTitle: true,
        title: Text('รายการบิล', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              receipts.length,
                  (receiptIndex) {
                final receipt = receipts[receiptIndex];

                // ตรวจสอบว่ามีรายการในประเภทนี้หรือไม่
                if (receipt.receiptItems.isEmpty) {
                  return SizedBox.shrink(); // ไม่มีข้อมูลในประเภทนี้
                }

                // ถ้ามีข้อมูลในประเภทนี้ให้แสดง
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'ประเภท: ${receipt.typeNameTh}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...List.generate(
                      receipt.receiptItems.length,
                          (itemIndex) => ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(receipt.receiptItems[itemIndex].imagePath), // ปรับเป็นเส้นทางที่ถูกต้อง
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                receipt.receiptItems[itemIndex].menuName,
                                style: TextStyle(fontSize: 14, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${receipt.receiptItems[itemIndex].price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'X ${receipt.receiptItems[itemIndex].qty}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${receipt.receiptItems[itemIndex].total.toStringAsFixed(2)}',
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
                            '${receipt.total.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartTable(controller: HomeController()),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text(
                      "กลับไปหน้าหลัก",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
