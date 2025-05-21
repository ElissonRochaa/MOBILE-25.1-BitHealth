
import 'package:bithealth_front_end/model/vaccination_model.dart';
import 'package:bithealth_front_end/services/vaccination_service.dart';
import 'package:flutter/foundation.dart';

class VaccinationController extends ChangeNotifier {

  final VaccinationService _vaccinationService = VaccinationService();
  List<VaccinationModel> vaccinationList = [];
  bool isLoading = false;

  Future<void> loadVaccination() async {
    isLoading = true;
    notifyListeners();

    try {
      vaccinationList = await _vaccinationService.fetchVaccination();
    } catch (e) {
      vaccinationList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}