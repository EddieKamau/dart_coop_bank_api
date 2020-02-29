import 'dart:convert';

import 'package:aqueduct/aqueduct.dart';
import 'package:dart_coop_bank_api/coop_bank/modules/coop_bank_modules.dart' show BankMpesaModule;
import 'package:dart_coop_bank_api/coop_bank/serializers/coop_bank_serializers.dart' show BankMpesaSerializer;

class BankMpesaController extends ResourceController{

  @Operation.post()
  Future<Response> transact(@Bind.body(require: ['phoneNo', 'amount', 'transactionCurrency', 'narration']) BankMpesaSerializer _bankMpesaSerializer)async{

    final BankMpesaModule _coopMpesa = BankMpesaModule(
      phoneNo: _bankMpesaSerializer.phoneNo,
      amount: _bankMpesaSerializer.amount,
      narration: _bankMpesaSerializer.narration,
      transactionCurrency: _bankMpesaSerializer.currency,
      refNumber: _bankMpesaSerializer.refNumber,
    );
    final _response = await _coopMpesa.send;
    dynamic _responseponseBody;

    // compute response
      if(_response['status'] != 0){
        return Response.serverError(body: {'message': 'An error occured!'});
      } else {
        final int _responseponseStatusCode = int.parse(_response['body'].statusCode.toString());
        
        try {
          _responseponseBody = json.decode(_response['body'].body.toString());
          _responseponseBody['refNumber'] = _bankMpesaSerializer.refNumber;
        } catch (e) {
          _responseponseBody = _response['body'].body; 
          _responseponseBody['refNumber'] = _bankMpesaSerializer.refNumber;
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