 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeControler extends GetxController {

  var tabIndex=0;

  var _showVehicleinfo=false.obs;
  bool get showVehicleArrivalInfo=>_showVehicleinfo.value;

       chanegvehicleArrivalInfo(bool valuex){
 _showVehicleinfo.value= valuex;
  }

    changeTabIndex(int index){
    tabIndex=index;
    update();

  }

}
