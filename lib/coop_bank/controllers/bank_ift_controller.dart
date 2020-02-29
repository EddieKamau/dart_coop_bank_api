import 'dart:convert';

import 'package:dart_coop_bank_api/coop_bank/modules/coop_bank_modules.dart' show BankInternalFundsTransferModule;
import 'package:dart_coop_bank_api/coop_bank/serializers/coop_bank_serializers.dart' show BankInternalFundsTransferSerializer;
import 'package:dart_coop_bank_api/dart_coop_bank_api.dart';


class BankInternalFundsTransferSendController extends ResourceController{

  @Operation.post()
  Future<Response> transact(@Bind.body(require: ['accountNumber', 'amount', 'transactionCurrency', 'narration']) BankInternalFundsTransferSerializer _bankInternalFundsTransferSerializer)async{

    final BankInternalFundsTransferModule _ift = BankInternalFundsTransferModule(
      accountNumber: _bankInternalFundsTransferSerializer.accountNumber,
      amount: _bankInternalFundsTransferSerializer.amount,
      transactionCurrency: _bankInternalFundsTransferSerializer.transactionCurrency,
      narration: _bankInternalFundsTransferSerializer.narration,
      refNumber: _bankInternalFundsTransferSerializer.refNumber,
    );
    final _response = await _ift.send;
    dynamic _responseponseBody;

    // compute response
      if(_response['status'] != 0){
        return Response.serverError(body: {'message': 'An error occured!'});
      } else {
        final int _responseponseStatusCode = int.parse(_response['body'].statusCode.toString());
        
        try {
          _responseponseBody = json.decode(_response['body'].body.toString());
          _responseponseBody['refNumber'] = _bankInternalFundsTransferSerializer.refNumber;
        } catch (e) {
          _responseponseBody = _response['body'].body; 
          _responseponseBody['refNumber'] = _bankInternalFundsTransferSerializer.refNumber;
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