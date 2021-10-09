 

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:waste/Root/constant.dart';
import 'package:waste/Root/globalFunction.dart';
import 'package:waste/Settings/UserSetting/BillPayment/AllBill/alluserModel.dart';
import 'package:waste/Settings/UserSetting/BillPayment/CreateBill/createbillModel.dart';
import 'package:waste/weekday/week.dart';

class homeuserBillController extends GetxController{

  
    List<createMonthyluBillModel> listofMonthlybillrate=[];
    List<billModelofMonth> listofModelMonth=[];
   List<String> listofHomeId=[];

   RxBool _isLoading=false.obs;
  bool get isLoading=>_isLoading.value;

  RxString _selectedHomeId="".obs;
  String get selectedIdHome  =>_selectedHomeId.value;

  RxString _selectedOwnerName="".obs;
  String get selectedOwnerName  =>_selectedOwnerName.value;

  int _MonthlyRateForHome=0;
  
  RxString _fromDate="2078/Baisakh".obs;
  String get fromDate  =>_fromDate.value;

  RxString _toDate="2078/Baisakh".obs;
  String get toDate  =>_toDate.value;


  RxString _totalAmounttoPay="0000.00".obs;
  String get totalAmounttoPay=>_totalAmounttoPay.value;

   RxString _totalFinetoPay="00.00".obs;
  String get totalFinetoPay=>_totalFinetoPay.value;
  var objeWeek= Week();

initData(){
  _toDate.value="";
  _totalFinetoPay.value="";
  _fromDate.value="";
  _totalAmounttoPay.value="";
  listofModelMonth=[]; 
  update();
}

getCurrentMonth(){
 print( objeWeek.nepaliMonthNameFromInt(0));
}
  

  changeVehicleId(String value){
_selectedHomeId.value=value;
 loadDataAccordingtoHomeId();
 }
  
////////////////////////////LOAD All Data According to home id
///
bool currentMonthMatchMonthlybill=true;


   loadDataAccordingtoHomeId() async{
  bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }

 _isLoading.value=true;
 listofModelMonth=[];
 update();

 NepaliDateTime nepaliDateTime= DateTime.now().toNepaliDateTime();
 var myFormat=NepaliDateFormat('yyyy-MM');
 var currentMonthyear=myFormat.format(nepaliDateTime);

  
  try{
    if(_selectedHomeId.value!=""){
     var snapshot= await FirebaseFirestore.instance.collection("homemonthlybill").
     doc(_selectedHomeId.value).collection("bill").orderBy(fieldserialDatetime, descending: true).
     get().catchError((e){
      BotToast.showText(text: e.toString());
     });

    for(int i=0; i<snapshot.docs.length;i++) {


     var element= snapshot.docs[i];
     _totalAmounttoPay.value=element.data()[fieldtotalAmount];
      String yearmonth=element.data()[fieldcurrentMonth];
       String year=yearmonth.substring(0,4);
       String month=  Week().nepaliMonthNameFromInt(int.parse( yearmonth.substring(5,7).toString()));
     String homeId=element.data()[fieldHomeId];
     double paidAmount=  double.parse(element.data()[fieldPaidAmount]);
     double  amountToPay= double.parse(element.data()[fieldtotalAmount]);
    bool paid; String transaction="";
    
    _toDate.value=snapshot.docs[0].data()[fieldcurrentMonth].substring(0,4);
    _toDate.value=   _toDate.value + '-'+
                   Week().nepaliMonthNameFromInt(int.parse(snapshot.docs[0].data()[fieldcurrentMonth]
                   .substring(5,7).toString()));

    _fromDate.value= month+'-'+year;

    _totalAmounttoPay.value=snapshot.docs[0].data()[fieldoverallTotal].toString();

        _totalFinetoPay.value=snapshot.docs[0].data()[fieldfine].toString();


     if(paidAmount>=amountToPay|| double.parse(snapshot.docs[0].data()[fieldoverallTotal].toString())==0 ){
  paid=true;
   transaction="Received";
     }else{
       paid=false;
   transaction="Pending";
     }

///SInce  create compare the datetime with the new data time
 //once the topmost data is of curren month// no  need to compare create monthly bill

if(snapshot.docs[0].data()[fieldcurrentMonth]!=currentMonthyear)
   await compareCreatMonthlyBill(element.data()); 

listofModelMonth.add(billModelofMonth(homeId:homeId, monthName: month, year: year, 
     paidAmount: paidAmount.toString(),totalAmount: amountToPay.toString(), 
     paid: paid, transaction: transaction, monthyluBillModel:  createMonthyluBillModel.fromMap(snapshot.docs[i].data())    )); 
    }
    }

  }catch(err){
    BotToast.showText(text: err.toString());
  }
  finally{
 _isLoading.value=false;  
 update();
  }
  }

////////////////////LAod all bill controller 
 getAllHomeId()async{
  bool hasInterent= await hasInsternet();

  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
  DisplayLoading.show(text: "Please wait...", display: true);
 listofHomeId=[];
 update();
  try{
     var snapshot= await FirebaseFirestore.instance.collection("homebill").get().catchError((e){
      BotToast.showText(text: e.toString());
     });

     if(snapshot.docs.length>0){
       snapshot.docs.forEach((element) {
      listofHomeId.add(element.data()[fieldHomeId]);
     update();
           });
       }else{
    BotToast.showText(text: "No Any user record found");
       }


  }catch(err){
    BotToast.showText(text: err.toString());
  }
  finally{
  DisplayLoading.show(text: "Please wait...", display: false);
  }
 }
///com
   Future<void> compareCreatMonthlyBill(Map<String, dynamic> documentData)async {
    NepaliDateTime nepaliDateTime= DateTime.now().toNepaliDateTime();
 var myFormat=NepaliDateFormat('yyyy-MM');
 var customDate=myFormat.format(nepaliDateTime);

 


 var  todayYear=int.parse(customDate.substring(0,4));
 var todayMonth=int.parse(customDate.substring(5,7));
  
  String yearmonth=documentData[fieldcurrentMonth];
  var incomingyear= int.parse(yearmonth.substring(0,4));
  var incomingMonth=   int.parse( yearmonth.substring(5,7));
//ist case

double _monthlyCharge=double.parse(documentData[fieldcurrentMonthcharge]);
double _overallAmount=  double.parse(documentData[fieldoverallTotal]);
double newOverAllTotal=_overallAmount;

print("today year"+todayYear.toString()+"today month"+todayMonth.toString());
print("Icoming year"+incomingyear.toString()+"Incoming month"+incomingMonth.toString());
  if(todayYear==incomingyear && todayMonth==incomingMonth){
    //no need insert into the firestore'
    print("No need to update on firestore");
    return;
  }


  //2 case
  if(todayYear==incomingyear && todayMonth>incomingMonth ){
    //   year is same but month few

    //incoming==2, today 4
    ////add remainig amount+currentMonthly charge

   for(int i=incomingMonth+1; i<=todayMonth; i++){
     print('////////'+i.toString()+'//'+incomingMonth.toString());
      //these are month/////////////////////
     newOverAllTotal= newOverAllTotal+_monthlyCharge;
  await createMonthlyBillAuto(documentData,todayYear,i,  _monthlyCharge, newOverAllTotal );

    }
    return;

  }

//3rd case
  if(todayYear>incomingyear){
    //   year is same but month few

    //incoming month==2, move upto 12
    //again increase year and move upto today month
//looping the year until the current year come
 for(int i=incomingyear; i<=todayYear;i++){
// if inyear=today year
  if(i==todayYear){
  
   for(int jj= 1; jj<=todayMonth; jj++){
   newOverAllTotal= newOverAllTotal+_monthlyCharge;
  createMonthlyBillAuto(documentData,todayYear,jj,  _monthlyCharge, newOverAllTotal );
    }
     }
//looping year with middle year

 else if(i!=incomingyear && i!=todayYear){
    for(int k= 1; k<=12; k++){
 newOverAllTotal= newOverAllTotal+_monthlyCharge;
  createMonthlyBillAuto(documentData, i,k,  _monthlyCharge, newOverAllTotal );
   }
  }
//looping with first year
  else if(i==incomingyear){
     if(incomingMonth==12){
       //skip
     }else{
       
    for(int l=incomingMonth+1; l<=12; l++){
      //these are month/////////////////////
  newOverAllTotal= newOverAllTotal+_monthlyCharge;
  createMonthlyBillAuto(documentData,i,l,  _monthlyCharge, newOverAllTotal );
    }

     }

     }
    
 }
   
  
  }

  ///////
  }
final box=GetStorage();
  Future<void> createMonthlyBillAuto(Map<String, dynamic> documentData, int year , 
  int month,  double monthlycharge, double newOverAlltotal, ) async{

     createMonthyluBillModel cd = new createMonthyluBillModel();
     String formatedMonth=month.toString();
     if(month.toString().length<=1)
     formatedMonth= '0'+month.toString();


     String NepaliDatetime=year.toString()+'-'+formatedMonth+'-20 12:27:00';
     NepaliDateTime parsedDatetime=NepaliDateTime.parse(NepaliDatetime);
    DateTime SerialDatetime=parsedDatetime.toDateTime();

    int serialDatetimeMillisecondEpoch= DateTime.now().microsecondsSinceEpoch;
   
   cd.serialDateTime=serialDatetimeMillisecondEpoch;
  
  cd.currentyearMonth=year.toString()+"-"+formatedMonth.toString();

  cd.currentMonthcharge= monthlycharge.toString();// retrieve it from monthly rate  firestore
  cd.remainingAmount="00.00";
  cd.paidAmount="00.00";
   cd.paidDate="0000-00-00";
   cd.overalltotalAmount=newOverAlltotal.toString();
   cd.fine="00.00";
   cd.totalAmount= monthlycharge.toString(); 
  cd.moderatorName=box.read(boxuserName);
 
 
  
  String docId=cd.currentyearMonth+'-'+_selectedHomeId.value;

 bool hasInterent= await hasInsternet();
  if(!hasInterent){
   BotToast.showText(text: "Try after Internet Connection");
   return;
  }
   DisplayLoading.show(text: "Creating bill...", display: true);

  
try{
await FirebaseFirestore.instance.collection("homemonthlybill").
  doc(_selectedHomeId.value).collection('bill').doc(docId).set(cd.toMap(cd)).whenComplete(() {
    BotToast.showText(text:  "We are operating internally."+docId);
  });
}catch(error){
  BotToast.showText(text: error.toString());
}
finally{
     DisplayLoading.show(text: "Please wait...", display: false);

}
   
  }


 
}