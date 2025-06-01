
import 'package:bithealth_front_end/model/campaigns_model.dart';
import 'package:bithealth_front_end/services/campaigns_service.dart';
import 'package:flutter/foundation.dart';

class CampaignsController extends ChangeNotifier {

  final CampaignsService _campaignsService = CampaignsService();
  List<CampaignsModel> vaccinationList = [];
  bool isLoading = false;

  Future<void> loadVaccination() async {
    isLoading = true;
    notifyListeners();

    try {
      vaccinationList = await _campaignsService.fetchCampaigns();
    } catch (e) {
      vaccinationList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}