import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_model/login/video_call.dart';

class Joinwithcode extends StatelessWidget {
  Joinwithcode({super.key});
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:InkWell(
              onTap: Get.back,
              child: Icon(Icons.arrow_back_ios_new_sharp,size:35),
            ),
            ),
            const SizedBox(height: 10,),
            Image.network("https://t4.ftcdn.net/jpg/00/97/58/97/360_F_97589769_t45CqXyzjz0KXwoBZT9PRaWGHRk5hQqQ.jpg",
              fit: BoxFit.cover,
              height: 200,
            ),
            const SizedBox(height: 20,),
            const Text(
              "Enter meeting code below",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15,20,15,0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                color: Colors.grey[350],
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Example: abc-efg-dhi"
                  ),
                ),
              ),
            ),

            Padding(
            padding: const EdgeInsets.fromLTRB(10,0, 0, 0),
            child: ElevatedButton(
              onPressed: (){
                Get.to(VideoCall());
              }, 
              // ignore: sort_child_properties_last, prefer_const_constructors
              child: Text("Join",style: TextStyle(color: Colors.white,),
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: Size(100,30),
              )
              
            
            ),
          ),
          ],
        ),
      )
    );
  }
}