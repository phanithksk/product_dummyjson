import 'package:produce_api/data/network/api_url.dart';
import 'package:produce_api/data/network/network_servise.dart';
import 'package:produce_api/model/category_model.dart';
import 'package:produce_api/model/product_model.dart';

class ProductRepository {
  final api = NetworkServise();

  //! Get Products
  Future<ProductModel> getAllProducts({
    required int limit,
    required int page,
  }) async {
    var res = ProductModel();
    String url = '${Api().productUrl}?limit=$limit&skip=$page';
    var response = await api.getApi(url);

    res = ProductModel.fromJson(response);
    return res;
  }

  //! Get Products
  Future<List<CategoryModel>> getCategory() async {
    List<CategoryModel> list = [];
    var categoryList = await api.getApi(Api().categoryUrl);
    categoryList.forEach((respone) {
      list.add(CategoryModel.fromJson(respone));
    });
    return list;
  }

  //! Get Products
  Future<ProductModel> getProductsBySlug(String slug) async {
    var res = ProductModel();
    var response = await api.getApi(Api().getProductBySlug + slug);
    res = ProductModel.fromJson(response);
    return res;
  }
}
