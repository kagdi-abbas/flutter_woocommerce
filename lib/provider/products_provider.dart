import 'package:flutter/material.dart';
import 'package:woocommerce_app/api/api_service.dart';
import 'package:woocommerce_app/models/products_item.dart';

class SortBy {
  String value, text, sortOrder;
  SortBy(this.value, this.text, this.sortOrder);
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductsProvider with ChangeNotifier{
  final List<ProductModel> _productsList = [];
  SortBy _sortBy = SortBy("popularity", "Popularity", "asc");
  int totalPages = 0;
  int pageSize = 10;

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;

  String _strSearch = "";
  String _categoryId = "";

  List<ProductModel> get allProducts => _productsList;

  double get totalRecords => _productsList.length.toDouble();

  LoadMoreStatus getLoadMoreStatus() => _loadMoreStatus;

  String get strSearch => _strSearch;
  String get categoryId => _categoryId;

  ProductsProvider(){
    resetStreams();
    _sortBy = SortBy("popularity", "Popularity", "asc");
  }

  void resetStreams(){
    _productsList.clear();
    setLoadMoreState(LoadMoreStatus.INITIAL);
  }

  setLoadMoreState(LoadMoreStatus loadMoreStatus){
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  fetchProducts(pageNumber, {
    String? strSearch,
    String? categoryId,
    String? sortBy,
    String? sortOrder = "asc",
  }) async {
    setLoadMoreState(LoadMoreStatus.LOADING);
    List<ProductModel>? itemModel = await APIService.getProducts(
      strSearch: _strSearch,
      pageNumber: pageNumber,
      pageSize: pageSize,
      categoryId: categoryId,
      sortBy: _sortBy.value,
      sortOrder: _sortBy.sortOrder,
    );

    if(itemModel!.isNotEmpty){
      _productsList.addAll(itemModel);
    }

    setLoadMoreState(LoadMoreStatus.STABLE);
    notifyListeners();

    setSortOrder(SortBy sortBy){
      _sortBy = sortBy;
      resetStreams();
    }

    setSearchStr(val){
      _strSearch = val;
      resetStreams();
      fetchProducts(1);
    }

    setProductCategory(val){
      _categoryId = val;
      _strSearch = "";
      resetStreams();
      fetchProducts(1);
    }
  }
}