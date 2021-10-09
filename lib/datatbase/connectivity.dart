import 'dart:io';

 class My_Wifi {

    Future<bool>Check() async {
      bool has_internet=false;
  try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  return has_internet=true;
  }
} on SocketException catch (_) {
   has_internet= false;
}
return has_internet;
}


}