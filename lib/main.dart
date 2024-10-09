import 'package:flutter/material.dart';
import 'package:produce_api/screen/products/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ProductsScreen(),
    );
  }
}
