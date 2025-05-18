import 'package:bithealth_front_end/model/unidade_saude_model.dart';
import 'package:bithealth_front_end/services/unidade_saude_service.dart';
import 'package:flutter/foundation.dart';



class UnidadeSaudeController extends ChangeNotifier {

  final UnidadeSaudeService _unidadeSaudeService = UnidadeSaudeService();
  List<UnidadeSaudeModel> unidadeSaudeList = [];
  bool isLoading = false;

  Future<void> loadMedicamentos() async {
    isLoading = true;
    notifyListeners();

    try {
      unidadeSaudeList = await _unidadeSaudeService.fetchDoctors();
    } catch (e) {
      unidadeSaudeList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}