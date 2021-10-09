import 'package:waste/Root/constant.dart';

class createMonthyluBillModel{

 
String currentyearMonth;
String currentMonthcharge;
String remainingAmount;
String totalAmount;
String paidAmount;
String fine;
String paidDate;
String moderatorName;
int serialDateTime;
String overalltotalAmount;

 
  createMonthyluBillModel
({
   this.serialDateTime,
   this.overalltotalAmount,
  this.currentyearMonth,
  this.currentMonthcharge,
  this.remainingAmount,
  this.totalAmount,
  this.paidAmount,
  this.paidDate,
  this.moderatorName
});


Map<String, dynamic> toMap(  createMonthyluBillModel
 model){


Map<String, dynamic> mappedData=new Map();

 mappedData[fieldserialDatetime]=this.serialDateTime;
 mappedData[fieldoverallTotal]= this.overalltotalAmount;

mappedData[fieldcurrentMonth]=model.currentyearMonth;
mappedData[fieldcurrentMonthcharge]= model.currentMonthcharge;
mappedData[fieldreainingamount]=model.remainingAmount;
mappedData[fieldfine]=model.fine;
mappedData[fieldtotalAmount]=model.totalAmount;
mappedData[fieldPaidAmount]=model.paidAmount;
mappedData[fieldpaidDate]=model.paidDate;
mappedData[fieldmoderator]=model.moderatorName;
return  mappedData;

}

 createMonthyluBillModel.fromMap(Map<String, dynamic> mappedData){


Map<String, dynamic> mappedData=new Map();

 
this.serialDateTime= mappedData[fieldserialDatetime] ;
this.overalltotalAmount=  mappedData[fieldoverallTotal];

currentyearMonth=mappedData[fieldcurrentMonth] ;
currentMonthcharge=mappedData[fieldcurrentMonthcharge] ;

remainingAmount=mappedData[fieldreainingamount] ;
fine=mappedData[fieldfine] ;
totalAmount=mappedData[fieldtotalAmount] ;
paidAmount=mappedData[fieldPaidAmount] ;
paidDate=mappedData[fieldpaidDate];
moderatorName=mappedData[fieldmoderator];
 

}




}