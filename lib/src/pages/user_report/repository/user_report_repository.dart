import 'package:piu_vino/src/constants/endpoints.dart';
import 'package:piu_vino/src/pages/user_report/result/user_report_result.dart';
import 'package:piu_vino/src/services/http_manager.dart';

class UserReportRepository {
  final HttpManager _httpManager = HttpManager();

  UserReportResult sucessSendOrError(Map<String, dynamic> result) {
    if (result['objectId'] != null) {
      return UserReportResult.success('Enviado com sucesso!');
    }
    if (result['error'] != null) {
      return UserReportResult.error(result['error']);
    }
    if (result['error'] != null) {
      return UserReportResult.error(result['error']);
    } else {
      return UserReportResult.error('Erro desconhecido');
    }
  }

  Future<UserReportResult> userSendReport(
      {required String userId, required String infoProblemn}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.userReport,
        method: HttpMethods.requisicaoPost,
        body: {
          "userId": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": userId
          },
          "infoProblemn": infoProblemn
        });
    return sucessSendOrError(result);
  }
}
