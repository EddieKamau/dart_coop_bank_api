import 'dart:convert';

import 'package:dart_coop_bank_api/coop_bank/configs/coop_bank_configs.dart';
import 'package:dart_coop_bank_api/coop_bank/modules/coop_bank_modules.dart' show fetchCoopToken;
import 'package:dart_coop_bank_api/dart_coop_bank_api.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class BankInternalFundsTransferModule{

  BankInternalFundsTransferModule({
    this.accountNumber,
    this.amount,
    this.transactionCurrency = 'KES',
    this.narration,
    this.refNumber,
  });


  String messageReference;
  String callBackUrl;
  String accountNumber;
  int amount;
  String transactionCurrency;
  String narration;
  String refNumber;

  String transactionType;
  String transactionAction;

  Future get send => _transact();

  Future _transact() async{
    // fetch configs
    final String _accountNumber = coopAccountNumber;
    final String _key = coopConsumerKey;
    final String _secret = coopConsumerSecret;


    final String callBackURL = coopCallbackUrl;
    final String _url = coopInternalFundsTransferUrl;
    final String _accessToken = await fetchCoopToken(key: _key, secret: _secret);

    messageReference = refNumber;


    final Map<String, dynamic> payload = {
      "MessageReference": messageReference,
      "CallBackUrl": callBackURL,
      "Source": {
        "AccountNumber": _accountNumber,
        "Amount": amount,
        "TransactionCurrency": transactionCurrency,
        "Narration": narration
      },
      "Destinations": [
        {
          "ReferenceNumber": '${messageReference}_1',
          "AccountNumber": accountNumber,
          "Amount": amount,
          "TransactionCurrency": transactionCurrency,
          "Narration": narration
        }
      ]
    };


    final Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
    };
    const bool trustSelfSigned = true;
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    final IOClient ioClient = IOClient(httpClient);
    try{
      final http.Response res = await ioClient.post(_url, headers: headers, body: json.encode(payload));

      return {
        'status': 0,
        'body': res,
      };
      
    } catch (e){
      return {'status': 1};
    }

  }
}