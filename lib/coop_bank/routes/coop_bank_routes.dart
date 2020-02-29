import 'package:dart_coop_bank_api/coop_bank/controllers/coop_bank_controllers.dart';
import 'package:dart_coop_bank_api/coop_bank/modules/coop_bank_modules.dart' show checkBalance;
import 'package:dart_coop_bank_api/dart_coop_bank_api.dart';

Router coopBankRoutes(Router router){
  // check balance
  router
    .route('bank/balance')
    .linkFunction((request)async{
      return Response.ok(await checkBalance());
    });

  // IFT
  router
    .route('bank/ift')
    .link(()=> BankInternalFundsTransferSendController());
  
  // Bank to mpesa
  router
    .route('bank/mpesa')
    .link(()=> BankMpesaController());
  
  // pesalink
  router
    .route('bank/pesalink')
    .link(()=> PesaLinkSendController());
  
  

  return router;
}