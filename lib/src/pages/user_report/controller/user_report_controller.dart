import 'package:flutter/material.dart';
import 'package:piu_vino/src/pages/user_report/repository/user_report_repository.dart';
import 'package:piu_vino/src/pages/user_report/result/user_report_result.dart';
import 'package:piu_vino/src/services/utils_services.dart';

class UserReportController with ChangeNotifier {
  final utilsServices = UtilsSerices();
  final userReportRepository = UserReportRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  isSendReport(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendUserReport(
      {required String userId, required String infoProblemn}) async {
    isSendReport(true);
    UserReportResult result = await userReportRepository.userSendReport(
        userId: userId, infoProblemn: infoProblemn);
    result.when(success: (mensagem) {
      utilsServices.showToast(message: mensagem);
    }, error: (mensagem) {
      utilsServices.showToast(message: mensagem, isError: true);
    });
    isSendReport(false);
  }
}
