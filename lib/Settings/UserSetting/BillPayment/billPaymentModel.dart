import 'package:get/get.dart';
import 'package:waste/Root/constant.dart';
import 'package:nepali_utils/nepali_utils.dart';

class HomeBillRate  {
  String homeId;
  int datetime;
  String  rate;
  String remainingamount;
  String startyearMonth;
  String ownerName;
  List<String>  newRate;
  List<String> newDate;


  HomeBillRate({
    this.homeId,
    this.datetime,
    this.rate,
    this.remainingamount,
    this.startyearMonth,
    this.ownerName,
    this.newDate,
    this.newRate
  });

  Map<String, dynamic> toMap(HomeBillRate billratemodel){

     NepaliDateTime nepaliDateTime= DateTime.now().toNepaliDateTime();
     var myFormat=NepaliDateFormat('yyyy-MM');
     var customDate=myFormat.format(nepaliDateTime);

    Map<String, dynamic> mappedData=Map();
    mappedData[fielddatetime]= billratemodel.datetime;
    mappedData[fieldreainingamount]= billratemodel.remainingamount;
    mappedData[fieldHomerate]= billratemodel.rate;
    mappedData[fieldHomeId]=billratemodel.homeId;
    mappedData[fieldstartyearMonth]= customDate ;
    mappedData[fieldOwnerName]=billratemodel.ownerName;
    mappedData[fieldnewRate]=[];
    mappedData[fieldNewDate]=[];
    return mappedData;

  }

  HomeBillRate.fromMap(Map<String, dynamic> mappedData){
           this.datetime=  mappedData[fielddatetime];
           this.rate=mappedData[fieldHomerate];
           this.homeId=  mappedData[fieldHomeId] ;
            this.remainingamount=mappedData[fieldreainingamount] ;
             this.startyearMonth=mappedData[fieldstartyearMonth] ;
  }

}

class HospitalBillRate {
  String hospitalName;
  int datetime;
  String  rate;
  


  HospitalBillRate({
    this.hospitalName,
    this.datetime,
    this.rate,
  });

  Map<String, dynamic> toMap(HospitalBillRate billratemodel){
    Map<String, dynamic> mappedData=Map();
    mappedData[fielddatetime]= billratemodel.datetime;
    mappedData[fieldHospitalrate]= billratemodel.rate;
    mappedData[fieldhospitalName]=billratemodel.hospitalName;

    return mappedData;
  }

 HospitalBillRate.fromMap(Map<String, dynamic> mappedData){
           this.datetime=  mappedData[fielddatetime];
           this.rate=mappedData[fieldHospitalrate];
           this.hospitalName=  mappedData[fieldhospitalName] ;
  }

}