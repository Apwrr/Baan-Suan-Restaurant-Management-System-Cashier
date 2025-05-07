class Receipt {
  final int id;
  final String receiptNo;
  final int table;
  final String typeNameTh;
  final double total;
  final List<ReceiptItem> receiptItems;

  Receipt({
    required this.id,
    required this.receiptNo,
    required this.table,
    required this.typeNameTh,
    required this.total,
    required this.receiptItems,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      receiptNo: json['receiptNo'],
      table: json['table'],
      typeNameTh: json['typeNameTh'],
      total: json['total'],
      receiptItems: (json['receiptItemDtoList'] as List)
          .map((item) => ReceiptItem.fromJson(item))
          .toList(),
    );
  }
}

class ReceiptItem {
  final int id;
  final int menuId;
  final String menuName;
  final String imagePath;
  final double price;
  final int qty;
  final double total;

  ReceiptItem({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.imagePath,
    required this.price,
    required this.qty,
    required this.total,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      id: json['id'],
      menuId: json['menuId'],
      menuName: json['menuName'],
      imagePath: json['imagePath'],
      price: json['price'],
      qty: json['qty'],
      total: json['total'],
    );
  }
}
