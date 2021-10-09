 
 
import 'package:flutter_email_sender/flutter_email_sender.dart';
var dataMap= Map<String, dynamic>();
 
class utils{


   

static Future<String> send() async {

  final Email email = Email(
  body: 'Email body',
  subject: 'Email subject',
  recipients: ['sc05213061@outlook.com'],
  cc: ['cc@example.com'],
  bcc: ['bcc@example.com'],
 // attachmentPaths: ['/path/to/attachment.zip'],
  isHTML: false,
);

 

    String platformResponse;

    try {
      print("iam here");
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      print("success on sending the sms");
    } catch (error) {
      platformResponse = error.toString();
      print("error on sending the sms"+error);

    }

    return platformResponse;

   
  }
}