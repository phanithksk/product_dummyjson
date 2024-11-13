String baseUrl = "https://dummyjson.com";
String basePostUrl = 'http://194.233.91.140:20099';

class Api {
  String productUrl = '$baseUrl/products';
  String categoryUrl = "$baseUrl/products/categories";
  String getProductBySlug = "$baseUrl/products/category/";

  String loginUrl = '$basePostUrl/api/oauth/token';
}
