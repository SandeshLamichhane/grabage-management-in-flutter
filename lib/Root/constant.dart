 const boxuserType="userType";
 const boxuserfrom="userfrom";
 const boxuserName="userName";
 const boxuserPhoneNumber="phoneNumber";
 const boxuserRole="userRole";
 const boxverifiedState="userverificationState";
 const boxblockState="userBlockState";
 const boxUserId='userId';
const boxUserHomeId='HomeId';
 const boxUserPassword="userPassword";
 const boxuserMarg='marg';
  const boxuserOda='oda';
 const boxuserLat='lat';
 const boxuserLong='long';
 const boxuserHospitalName='hospitalName';
 const boxuserdistrict='district';
 const boxuserjoined="joinedDate";

 const boxusergeopoint="geopint";

const boxStreaming='streaming';
const boxVehicleId='vehicleId';
const boxtodayroute='todayroute';
const boxhospitalId="hospitalId";

 const fieldvehicleId='truckNo';
 const fieldDriverid='driverId';
 const fieldTruckLocation='truckGeoPoint';
const fieldDriverName='driverName';
const fieldDriverPhone='driverPhone';
const fieldTruckStreaming='streaming';

const fieldnextTime='nextTime';
const fielddistrictName='districtName';
const fieldhospitalName='hospitalName';


const fieldrouteId='routeId';
const fieldmarg='marg';
const fieldoda='oda';
const fieldbaar='baar';
const fieldtimeInterval='timeInterval';
const fieldchowkLatLng='chowkLatLng';
const fieldsearchKeyword='searchKeyword';
const fieldtodayDate='date';
const fieldtodayrouteId='todayRouteModelid';
const fielddestinedtime='destinedTime';
const fieldcoveredtime='coveredtime';
const fieldcovered='covered';
const fieldfirestoreuploadtime='firestoreuploadtime';
const fieldoffline='offline';
const fieldGeopoint="userPoint";



const fieldgunasoId="gunasoId";
const  fieldgunasotitle="gunasotitle";
const fieldgunasodescription="gunasodescription";
const fieldgunasoquestionDate="gunasoDate";
const fieldgunasouser="gunasoUser";
const fieldgunasouserfrom="gunasoUserfrom";
const fieldgunasouserAddress='gunasouserAddress';
const fieldgunasomoderatorName="gunasoresponser";
const fieldgunasoreplytext="gunasoreplytext";
const fieldgunasoreplyDate="ginasoreplydate";
const fieldgunasopending="gunasopending";
const fieldgunasouserId="gunasouserId";
const fieldgunasomoderatorRole="gunasomoderatorRole";
const fieldHospId="HospIdNo";
const fieldHomeId="HomeIdNo";
const fieldHomerate="rate";
 const fielddatetime="datetime";
 const fieldHospitalrate="rate";

 const fielduserName='userName';
    
 const fieldreainingamount="reaminingamount";
 const fieldstartyearMonth="startyearMonth";
 const fieldOwnerName="Owner";
  const fieldcurrentMonth="currentMonth";
  const fieldUploadTime="uploadtime";
  const fieldserialDatetime="serialDatetime";
  const fieldoverallTotal="overalltotal";
 const fieldpending="pending";
 const fieldUserId='userId';

  const fieldcurrentMonthcharge="currentMonthcharge";
  const fieldfine="fine";
  const fieldtotalAmount="totalAmount";
  const fieldPaidAmount="paidAmount";
  const fieldpaidDate="paidDate";
  const fieldmoderator="moderator";
  const fieldNewDate="ratechangeDate";
  const fieldnewRate="ratenewrate";

  

 enum Block{ yes, no}

enum UserType{
  moderator, driver, admin,user
}
List<String> allNepalDistricts= [
   
 "Taplejung",
"Panchthar"	, 
 "Ilam",
 "Jhapa" ,
 	"Morang",	 
 "Sunsari",	 
	"Dhankutta"	 ,
 "Sankhuwasabha"	 ,
 "Bhojpur",	 
 	"Terhathum"	 ,
 	"Okhaldunga",
 	"Khotang"	, 
 	"Solukhumbu"	 ,
 	"Udaypur"	 ,
 "Saptari"	, 
 "Siraha"	, 
 	"Dhanusa"	 ,
 	"Mahottari"	 ,
 "Sarlahi",	 
 	"Sindhuli",	 
 "Ramechhap",	 
 	"Dolkha",	 
 	 	"Sindhupalchauk"	 ,
 	"Kavreplanchauk"	 ,
 	"Lalitpur"	, 
 	"Bhaktapur",
 "Kathmandu",
 	"Nuwakot"	 ,
 	"Rasuwa"	, 
 	"Dhading"	, 
 	 "Makwanpur"	 ,
 "Rauthat",	 
 	"Bara"	, 
 	"Parsa"	, 
 	"Chitwan"	 ,
 	"Gorkha",
 	"Lamjung"	 ,
 	"Tanahun" ,
 	"Syangja"	, 
 	"Kaski"	 ,
 	"Manag"	 ,
 	 	"Mustang"	 ,
 	"Parwat",	 
 	"Myagdi"	 ,
 	"Baglung"	 ,
 	 	"Gulmi"	, 
 	"Palpa"	, 
 	"Nawalpur"	, 
 	"Parasi",	 
 	"Rupandehi"	 ,
 	"Arghakhanchi"	 ,
 	"Kapilvastu"	 ,
 	 "Pyuthan",
 	"Rolpa"	 ,
 "Rukum Purba",
 "Rukum Paschim",
 	"Salyan"	, 
 	"Dang",	 
 	 	"Bardiya"	 ,
 	"Surkhet"	 ,
 	"Dailekh",	 
 	"Banke"	, 
 	"Jajarkot"	 ,
 	"Dolpa"	 ,
 	"Humla"	, 
  "Kalikot"	 ,
 	"Mugu",	 
 	"Jumla"	, 
 	 "Bajura"	 ,
 	"Bajhang"	, 
 	"Achham",	 
 	"Doti"	, 
 	"Kailali"	, 
 	 	"Kanchanpur"	 ,
 	"Dadeldhura",	 
 	"Baitadi"	 ,
 	"Darchula"	 
];