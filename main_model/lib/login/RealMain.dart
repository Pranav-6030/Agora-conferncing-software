import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:main_model/login/GroupDiscussion.dart';
// import 'package:get/get.dart';
// import 'package:main_model/login/signup.dart';
 



class RealMain extends StatelessWidget{
  const RealMain({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: GestureDetector(
          onTap: () {
            // Get.to(Login());
          },
          child: Padding(
            padding: const EdgeInsets.only(left:10,top: 10),
            child: Container(
              //basically leading widgets are used on left side
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 164, 83, 46),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              // child: SvgPicture.asset(
              //   'assets/icons/Arrow - Left 2.svg',
              //   height: 20,
              //   width: 20,
              // ),
            ),
          ),
        ),

        title: const Text(
          'Verbal Skill',
          style: TextStyle(
            color: Colors
                .black, //this was not needed for me for some reason it was already black
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      
      body: Column(
       children: [
          const SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: (){
              Get.to(GDinterface());
            },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
              ),
              height: 160,
              width: double.infinity,
            ),
          ),
          ),
          
          const SizedBox(
            height: 40,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:  2,
                  crossAxisSpacing: 10,
                
                ),
                itemCount: 2,
                itemBuilder: (context, int i){
                  return Container(                
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
                        ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
          'Real Time Interaction',
          style: TextStyle(
            color: Colors
                .black, //this was not needed for me for some reason it was already black
            fontSize: 18,
            fontWeight: FontWeight.bold,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8,bottom: 60,right: 8),
            child: Container(
              decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
              ),
              height: 160,
              width: double.infinity,
            ),
          ),
          
        ],
      )

      
        
      
      
      
    );
  }
}