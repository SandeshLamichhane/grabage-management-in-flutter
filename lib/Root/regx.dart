
extension extString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = new RegExp(
         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
      //  r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$');

    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}
/////////////////////////////////////////////// CUSTOM FUNCTION BUT EXPENSIVE

String validatePhone(String value) {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    var val= phoneRegExp.hasMatch(value);

    
  if(value.isEmpty){
    print("value is empty");
    return "required";
  }
  else if (val){
    return "Invalid Phonex Number";
  }
 
 return null;
 
}
String isValidPhoneNumber(String string)  {
  // Null or empty string is invalid phonasynce number
  print("phone number is /////////////////////"+string.toLowerCase());
  if (string.trim().isEmpty) {
    return "";
  }
 const pattern =  r'^(?:[9]8)?[0-9]{8}$';
   var regExp = RegExp(pattern); 
    if (!regExp.hasMatch(string)) {
    return "Invalid Phone Number";
  }
  return null;
}

String isValidEmailAddress(String string) {
  // Null or empty string is invalid phone number
  print("emai number is /////////////////////"+string.toLowerCase());
  if ( string.trim().isEmpty) {
    return "Empty";
  }
 bool emailValid = 
 RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(string);
 
    if (!emailValid) {
    return "Invalid email Address";
  }
  return null;

}
String isValidName(String string) {
  // Null or empty string is invalid phone number
  print("Incoming value /////////////////////"+string.toLowerCase());
  if ( string.trim().isEmpty) {
    return "";
  }
 bool emailValid = 
 RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$").hasMatch(string);
 
    if (!emailValid) {
    return "Invalid name";
  }
  return null;
}



bool isValidpin(String string) {
  string.trim();
    if ( string.trim().isEmpty) {
    
    return false;
  }
 print(RegExp( r'(^[0-9]{6}$)').hasMatch(string));
 //bool isValid = RegExp(r"^[0-9]$").hasMatch(string);
     return RegExp( r'(^[0-9]{6}$)').hasMatch(string);

 
}