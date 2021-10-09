import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createbillModel.dart';

class billModelofMonth {
  String monthName;
  String yearName;
  String paidAmount;
  String totalAmount;
  String year;
  String homeId;
  String transaction;
  bool paid;
  createMonthyluBillModel  monthyluBillModel;

  billModelofMonth({
    this.monthName,
    this.yearName,
    this.paidAmount,
    this.totalAmount,
    this.paid,
    this.transaction,
    this.year,
    this.homeId,
    this.monthyluBillModel,
    
  });
}