import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:main_model/login/join_with_code.dart';
import 'package:main_model/login/new_meeting.dart';
import 'package:main_model/login/video_call.dart';

class GDinterface extends StatelessWidget {
  const GDinterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            // Get.to(Login());
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 164, 83, 46),
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30), 
                child: Image.network('https://media.giphy.com/media/dvdcBNbAiNVT9Z0iwP/giphy.gif', fit: BoxFit.cover,),
              ),
            ),

          ),
        ),
        title: const Text(
          'Group Discussion',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 60, right: 8, top: 10),
                child: Container(//Container
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 251, 253, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        spreadRadius: 2, // How wide the shadow spreads
                        blurRadius: 5, // How soft the shadow looks
                        offset: const Offset(0, 3), // Offset in x and y directions (x, y)
                    ),
                    ],
                  ),
                  height: 160,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 200),
                          child: Text(
                            "<Topic>\n",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 250, top: 45),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(VideoCall(channelName: "test",));
                            },
                            
                            label: const Text(
                              "Join",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              fixedSize: const Size(100, 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Add your button action here
                _displayBottomSheet(context);
              },              
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: const CircleBorder() 
              ),
              child: const Icon(Icons.add, color: Colors.white,size: 30,),
            ),
          ),
        ],
      ),
    );
  }
}

Future _displayBottomSheet(BuildContext context){
  return showModalBottomSheet(
    context: context, 
    backgroundColor:  Colors.white,
    
    builder: (context) => Container(
      height: 250,
      width: double.infinity,
      
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
            child: ElevatedButton.icon(
              onPressed: (){
                Get.to(NewMeeting());
              }, 
              // ignore: prefer_const_constructors
              icon: Icon(Icons.add,color: Colors.white) ,
              // ignore: prefer_const_constructors
              label: Text("New Meeting",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: const Size(325,30),
              )
              
            
            ),
          ),

          const Divider(thickness: 1,height: 40,indent: 20,endIndent: 20,),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,0,0),
            child: OutlinedButton.icon(
              onPressed: (){
                // ignore: prefer_const_constructors
                Get.to(Joinwithcode());
              },
              icon: const Icon(Icons.margin,color: Colors.indigo,),
              label: const Text("Join with a code",style: TextStyle(color: Colors.indigo),),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.indigo),
                fixedSize: const Size(325,30),
              )
            ),
          ),
        ]
      )
    )

    
    );
}