
import 'package:bithealth_front_end/model/services_model.dart';
import 'package:bithealth_front_end/services/services_service.dart';
import 'package:flutter/foundation.dart';

class ServicesController extends ChangeNotifier {

  final ServicesService _servicesService = ServicesService();
  List<ServicesModel> servicesList = [];
  bool isLoading = false;

  Future<void> loadServices() async {
    isLoading = true;
    notifyListeners();

    try {
      servicesList = await _servicesService.fetchServices();
    } catch (e) {
      servicesList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}