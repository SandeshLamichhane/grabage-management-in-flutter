import 'package:flutter/material.dart';

class DropDownSelectBox extends StatefulWidget {
 String labelText;
 Function(String) onchange;
 List<String> listitem;
 Icon iconata= Icon(Icons.person);
 Function (String) validator;

 
  DropDownSelectBox({this.labelText, this.onchange, this.listitem, this.iconata});

  @override
  _DropDownSelectBoxState createState() => _DropDownSelectBoxState();
}

class _DropDownSelectBoxState extends State<DropDownSelectBox> {

   String _chosenValue;
  
  @override
  Widget build(BuildContext context) {
    return  
          Container(
             child: (
                FormField<String>(
                
                builder: (FormFieldState<String> state) {
                  
                  
                  return InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon:   widget.iconata,
                   errorStyle: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
               
               
                   focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.green, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(width: 1.5, color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(width: 1.5, color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(width: 1.5, color: Colors.green),
                ),
                contentPadding:
                    const EdgeInsets.only(left: 15.0, bottom: 8.0, top: 8.0),
                filled: true,
                fillColor: Colors.green.withOpacity(0.1),
               // hintText: "Select your oda",//controller.currentOdaNoselected,
                 labelText: _chosenValue==null? null: widget.labelText,
                 labelStyle: TextStyle(fontSize: 16)
                ),
                
        
                 child: DropdownButtonHideUnderline(
                   
                   child: DropdownButtonFormField<String>(
                     validator: (value){
                     return null;
                     },
                     decoration: InputDecoration(
             border: InputBorder.none,
             
             ),
                    
                    focusColor:Colors.white,
                    value:    _chosenValue, //its the initail value 
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor:Colors.white,
                    items:  widget.listitem.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,// it itereate and save the value to the dropdwonw sidget
                        child: Text(value,style:TextStyle(fontWeight: FontWeight.w400),),
                      );
                    }).toList(),
                    hint:Text(
                     widget.labelText,
                      style: TextStyle(
                    
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                    ),
                    onChanged: (String value) {
                      // i need void call back funcion to get data
                      widget.onchange(value);
                   setState(() {
                     _chosenValue=value;
                   });
                    },
                        
                    )
                  ));
                  }
                 
                     
                 
                  
                
               )
             ),
           );
  }
}