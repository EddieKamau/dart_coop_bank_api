import 'dart:convert';

import 'package:dart_coop_bank_api/coop_bank/modules/coop_bank_modules.dart' show BankPesalinkModule;
import 'package:dart_coop_bank_api/coop_bank/serializers/coop_bank_serializers.dart' show BankPesalinkSerializer;
import 'package:dart_coop_bank_api/dart_coop_bank_api.dart';

class PesaLinkSendController extends ResourceController{
  
  @Operation.post()
  Future<Response> transact(@Bind.body(require: ['accountNumber', 'amount', 'transactionCurrency', 'narration', 'bankCode']) BankPesalinkSerializer _bankPesalinkSerializer)async{
    
    final BankPesalinkModule _pesalink = BankPesalinkModule(
      accountNumber: _bankPesalinkSerializer.accountNumber,
      amount: _bankPesalinkSerializer.amount,
      transactionCurrency: _bankPesalinkSerializer.transactionCurrency,
      narration: _bankPesalinkSerializer.narration,
      bankCode: _bankPesalinkSerializer.bankCode,
      refNumber: _bankPesalinkSerializer.refNumber,
    );
    final _response = await _pesalink.send;
    dynamic _responseponseBody;

    // compute response
      if(_response['status'] != 0){
        return Response.serverError(body: {'message': 'An error occured!'});
      } else {
        final int _responseponseStatusCode = int.parse(_response['body'].statusCode.toString());
        
        try {
          _responseponseBody = json.decode(_response['body'].body.toString());
          _responseponseBody['refNumber'] = _bankPesalinkSerializer.refNumber;
        } catch (e) {
          _responseponseBody = _response['body'].body; 
          _responseponseBody['refNumber'] = _bankPesalinkSerializer.refNumber;
        }

        switch (_responseponseStatusCode) {
          case 200:
            return Response.ok(_responseponseBody);
            break;
          case 400:
            return Response.badRequest(body: _responseponseBody);
            break;
          default:
            return Response.serverError(body: _responseponseBody);
        }
      }

  }
}