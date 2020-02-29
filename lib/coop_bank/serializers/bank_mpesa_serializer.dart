import 'package:dart_coop_bank_api/dart_coop_bank_api.dart';

class BankMpesaSerializer extends Serializable{
  String phoneNo;
  int amount;
  String narration;
  String currency;
  String refNumber;

  @override
  Map<String, dynamic> asMap() {
    return {
      "phoneNo": phoneNo,
      "amount": amount,
      "narration": narration,
      "currency": currency,
      "refNumber": refNumber,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    phoneNo = object['phoneNo'].toString();
    amount = int.parse(object['amount'].toString());
    narration = object['narration'].toString();
    currency = object['currency'].toString();
    refNumber = object['refNumber'].toString();
  }

}