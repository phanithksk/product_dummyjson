import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:produce_api/controller/product_controller.dart';
import 'package:produce_api/repository/product_repository.dart';
import 'package:produce_api/screen/auth/login_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/change_lang_controller.dart';
import '../widget/custom_card_product.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final controller = Get.put(ProductController(ProductRepository()));
  final langController = Get.put(ChangeLanguageController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    controller.getAllProductData();
  }

  final _isLoadingMore = false.obs;
  Future<void> _scrollListener() async {
    if (!controller.hasMoreData.value || controller.isLoading.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      if (!_isLoadingMore.value) {
        setState(() {
          _isLoadingMore.value = true;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        debugPrint("----selectCategory:${controller.selectCategory.value}");
        // controller.selectCategory.value != 0
        //     ? await controller.getPaginationByCategory()
        //     :
        await controller.getAllProductData();
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          _isLoadingMore.value = false;
        });
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEEE),
      appBar: AppBar(
        backgroundColor: const Color(0xff5D44AD),
        centerTitle: true,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              },
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              "product".tr,
              style: TextStyle(
                fontSize: 18,
                fontFamily: Get.locale == const Locale('km', 'KM')
                    ? 'KH-BOLD'
                    : 'ROBOTO-BOLD',
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 50,
            )
          ],
        ),
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                controller.isGrid.value = !controller.isGrid.value;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  controller.isGrid.value ? Icons.grid_view : Icons.list,
                  color: Colors.white,
                  size: controller.isGrid.value ? 25 : 32,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (Get.locale == const Locale('km', 'KM')) {
                langController.updateLanguage('English');
              } else {
                langController.updateLanguage('Khmer');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 13,
                backgroundImage: AssetImage(
                  Get.locale == const Locale('km', 'KM')
                      ? 'assets/kh.png'
                      : 'assets/en.png',
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: const Color(0xff5D44AD).withOpacity(0.4),
        color: Colors.white,
        onRefresh: () async {
          if (controller.categoryList.isEmpty) {
            await controller.getCategoryData();
          }
          await controller.refreshProducts();
        },
        child: Obx(() {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      child: controller.categoryList.isEmpty
                          ? buildShimmer()
                          : Row(
                              children: [
                                ...List.generate(controller.categoryList.length,
                                    (index) {
                                  var data = controller.categoryList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      controller.onCategorySelected(index);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              controller.selectCategory.value ==
                                                      index
                                                  ? const Color(0xff5D44AD)
                                                  : const Color(0xff5D44AD)
                                                      .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          data.name ?? "",
                                          style: TextStyle(
                                            color: controller
                                                        .selectCategory.value ==
                                                    index
                                                ? Colors.white
                                                : const Color(0xff391E92),
                                            fontSize: 16,
                                            fontFamily: 'ROBOTO-MEDIUM',
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                controller.isGrid.value == false
                    ? Flexible(
                        child: Stack(
                          children: [
                            ListView.builder(
                              controller: scrollController,
                              itemCount: controller.productList.length +
                                  (controller.hasMoreData.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < controller.productList.length) {
                                  final product = controller.productList[index];
                                  return customContainer(
                                    price: product.price.toString(),
                                    title: product.title,
                                    thumbnail: product.thumbnail,
                                    view: product.weight.toString(),
                                  );
                                }
                                return null;
                              },
                            ),
                            // Optional loading indicator at the bottom
                            Obx(() {
                              return _isLoadingMore.value &&
                                      controller.hasMoreData.value
                                  ? Positioned(
                                      bottom: 25,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 68, 50, 128),
                                              Color.fromARGB(255, 112, 87, 193)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 7,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 130,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Platform.isAndroid
                                                ? SizedBox(
                                                    height: Get.height * 0.02,
                                                    width: Get.height * 0.021,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 1.5,
                                                    ),
                                                  )
                                                : const CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                    radius: 12,
                                                    animating: true,
                                                  ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              Get.locale ==
                                                      const Locale('km', 'KM')
                                                  ? "កំពុងទាញយក"
                                                  : "Loading",
                                              style: TextStyle(
                                                fontSize:
                                                    context.isPhone ? 14 : 16,
                                                fontFamily: Get.locale ==
                                                        const Locale('km', 'KM')
                                                    ? 'KH-REGULAR'
                                                    : 'EN-REGULAR',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }),
                          ],
                        ),
                      )
                    : Flexible(
                        child: GridView.builder(
                            itemCount: controller.productList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            itemBuilder: (_, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                      spreadRadius: 2,
                                      color: const Color(0xff929292)
                                          .withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      height: 100,
                                      imageUrl: controller
                                          .productList[index].thumbnail,
                                      progressIndicatorBuilder:
                                          (context, url, progress) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 300,
                                          child: Shimmer.fromColors(
                                            baseColor: const Color(0xff5D44AD)
                                                .withOpacity(0.1),
                                            highlightColor:
                                                const Color(0xff5D44AD)
                                                    .withOpacity(0.2),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          "assets/no-image.png",
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.productList[index].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'ROBOTO-REGULAR',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Price : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'ROBOTO-REGULAR',
                                                    ),
                                                  ),
                                                  Text(
                                                    '\$${controller.productList[index].price}',
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'ROBOTO-MEDIUM',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "View : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'ROBOTO-REGULAR',
                                                    ),
                                                  ),
                                                  Text(
                                                    controller
                                                        .productList[index]
                                                        .weight
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'ROBOTO-MEDIUM',
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget buildShimmer() {
  return Row(
    children: List.generate(
      5,
      (index) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Shimmer.fromColors(
          baseColor: const Color(0xff5D44AD).withOpacity(0.3),
          highlightColor: const Color(0xff5D44AD).withOpacity(0.8),
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    ),
  );
}
