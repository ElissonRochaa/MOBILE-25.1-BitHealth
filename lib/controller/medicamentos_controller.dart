import 'package:bithealth_front_end/model/medicamentos_model.dart';
import 'package:bithealth_front_end/services/medicamento_service.dart';
import 'package:flutter/foundation.dart';



class MedicamentosController extends ChangeNotifier {

  final MedicamentoService _medicamentoService = MedicamentoService();
  List<MedicamentosModel> medicamentos = [];
  bool isLoading = false;

  Future<void> loadMedicamentos() async {
    isLoading = true;
    notifyListeners();

    try {
      medicamentos = await _medicamentoService.fetchMedicamentos();
    } catch (e) {
      medicamentos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}