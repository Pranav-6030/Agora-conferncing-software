import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_model/login/RealMain.dart'; 

class Login extends StatelessWidget{
  const Login({super.key});
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      color: Colors.black87,
      child: Column(
        children: [
          const SizedBox(height: 600,),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
            child: ElevatedButton.icon(
              onPressed: (){
                Get.to(RealMain());
              }, 
              label: Text("Sign up page",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: Size(325,30),
              )
              
            
            ),
          ),
        ]
    ),
  ),
  );
}


}