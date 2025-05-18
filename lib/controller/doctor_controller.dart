import 'package:bithealth_front_end/model/doctor_model.dart';
import 'package:bithealth_front_end/services/doctor_service.dart';
import 'package:flutter/foundation.dart';



class DoctorController extends ChangeNotifier {

  final DoctorService _doctorService = DoctorService();
  List<DoctorModel> doctorList = [];
  bool isLoading = false;

  Future<void> loadMedicamentos() async {
    isLoading = true;
    notifyListeners();

    try {
      doctorList = await _doctorService.fetchDoctors();
    } catch (e) {
      doctorList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}