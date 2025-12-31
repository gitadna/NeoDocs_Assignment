import 'package:flutter/material.dart';
import '../models/range_model.dart';
import '../services/api_service.dart';

class RangeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<RangeModel> ranges = [];
  bool isLoading = false;
  String? error;
  double inputValue = 0;

  Future<void> loadRanges() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      ranges = await _apiService.fetchRanges();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void updateInput(double value) {
    inputValue = value;
    notifyListeners();
  }
}
