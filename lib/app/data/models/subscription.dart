class Subscription {
  final String id;
  final String productId;
  final String productName;
  final String warehouseName;
  final String storeName;
  final int quantity;
  final int frequencyDays;
  final String status;
  final double pricePerCycle;
  final String nextDeliveryDate;
  final double? distanceKm;

  Subscription({
    required this.id,
    required this.productId,
    required this.productName,
    required this.warehouseName,
    required this.storeName,
    required this.quantity,
    required this.frequencyDays,
    required this.status,
    required this.pricePerCycle,
    required this.nextDeliveryDate,
    this.distanceKm,
  });

  factory Subscription.fromJson(Map<String, dynamic> j) => Subscription(
    id: j['id'],
    productId: j['product_id'],
    productName: j['product_name'],
    warehouseName: j['warehouse_name'],
    storeName: j['store_name'],
    quantity: (j['quantity'] as num).toInt(),
    frequencyDays: (j['frequency_days'] as num).toInt(),
    status: j['status'],
    pricePerCycle: (j['price_per_cycle'] as num).toDouble(),
    nextDeliveryDate: j['next_delivery_date'],
    distanceKm:
        j['distance_km'] == null ? null : (j['distance_km'] as num).toDouble(),
  );
}
