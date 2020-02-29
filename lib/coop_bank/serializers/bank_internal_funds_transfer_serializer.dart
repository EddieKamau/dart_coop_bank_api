import 'package:dart_coop_bank_api/dart_coop_bank_api.dart';

class BankInternalFundsTransferSerializer extends Serializable{
  String accountNumber;
  int amount;
  String transactionCurrency;
  String narration;
  String refNumber;

  @override
  Map<String, dynamic> asMap() {
    return {
      "accountNumber": accountNumber,
      "amount": amount,
      "transactionCurrency": transactionCurrency,
      "narration": narration,
      "refNumber": refNumber,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    accountNumber = object['accountNumber'].toString();
    amount = int.parse(object['amount'].toString());
    transactionCurrency = object['transactionCurrency'].toString();
    narration = object['narration'].toString();
    refNumber = object['refNumber'].toString();
  }

}