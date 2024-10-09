import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:produce_api/model/category_model.dart';
import 'package:produce_api/model/product_model.dart';
import 'package:produce_api/repository/product_repository.dart';

class ProductController extends GetxController {
  var productList = <Products>[].obs;
  final isLoading = false.obs;
  final ProductRepository productRepository;
  final RxBool isGrid = false.obs;
  final hasMoreData = true.obs;
  int currentPage = 1;
  final int limit = 5;
  ProductController(this.productRepository);

  @override
  void onInit() {
    getCategoryData();
    super.onInit();
  }

  //! Get Products
  Future<void> getAllProductData() async {
    if (isLoading.value || !hasMoreData.value) {
      return;
    }
    isLoading(true);
    try {
      var obj = await productRepository.getAllProducts(
        limit: limit,
        page: currentPage,
      );
      if (obj.products != null && obj.products!.isNotEmpty) {
        productList.addAll(obj.products!);
        currentPage++;
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      debugPrint('------Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  //! Get Category
  var categoryList = <CategoryModel>[].obs;
  final isloadingCate = false.obs;
  final selectCategory = 0.obs;
  Future<void> getCategoryData() async {
    try {
      isloadingCate(true);
      var obj = await productRepository.getCategory();
      var allCategoryData = CategoryModel(name: 'All', slug: 'all');
      categoryList.value = [allCategoryData, ...obj];
      selectCategory.value = 0;

      await getAllProductBySlug('all');
    } finally {
      Future.delayed(const Duration(seconds: 3));
      isloadingCate(false);
    }
  }

  //! Get Products By Slug
  Future<void> getAllProductBySlug(String slug) async {
    try {
      isLoading(true);
      productList.value = [];
      ProductModel obj;
      if (slug == "all") {
        obj = await productRepository.getAllProducts(
          limit: limit,
          page: currentPage,
        );
      } else {
        obj = await productRepository.getProductsBySlug(slug);
      }

      productList.addAll(obj.products ?? []);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      Future.delayed(const Duration(seconds: 3));
      isLoading(false);
    }
  }

// Refresh products based on the selected category
  Future<void> refreshProducts() async {
    if (categoryList.isNotEmpty) {
      String selectedSlug = categoryList[selectCategory.value].slug ?? "all";

      await getAllProductBySlug(selectedSlug);
    } else {
      await getCategoryData();
    }
  }

  void onCategorySelected(int index) {
    if (index == 0) {
      getAllProductBySlug('all');
    }
    selectCategory.value = index;
    String selectedSlug = categoryList[index].slug ?? "all";
    getAllProductBySlug(selectedSlug);
  }
}
