import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/warehouse_controller.dart';

class WarehouseView extends GetView<WarehouseController> {
  const WarehouseView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WarehouseView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WarehouseView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
