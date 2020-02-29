import 'dart:convert';

import 'package:dart_coop_bank_api/coop_bank/configs/coop_bank_configs.dart';
import 'package:dart_coop_bank_api/coop_bank/modules/coop_bank_modules.dart' show fetchCoopToken;
import 'package:dart_coop_bank_api/dart_coop_bank_api.dart';
import 'package:http/io_client.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:http/http.dart' as http;

Future checkBalance() async {
  // fetch configs
  final String _accountNumber = coopAccountNumber;
  final String _key = coopConsumerKey;
  final String _secret = coopConsumerSecret;

  final String _accessToken = await fetchCoopToken(key: _key, secret: _secret);
  final Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
  };

  final String messageReference = ObjectId().toJson();
  final Map<String, dynamic> payload = {
    "MessageReference": messageReference,
    "AccountNumber": _accountNumber
  };


  const bool trustSelfSigned = true;
  final HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  final IOClient ioClient = IOClient(httpClient);
  try{
    final http.Response r = await ioClient.post(coopAccountBalanceUrl, headers: headers, body: json.encode(payload));
    return json.decode(r.body);
  } catch (e){
    return e.toString();
  }

}