import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewMeeting extends StatelessWidget {
  const NewMeeting({super.key});

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
                child: const Icon(Icons.arrow_back_ios_new_sharp,size:35),
              ),
              ),
              const SizedBox(height: 10,),
            Image.network("https://cdn.impossibleimages.ai/wp-content/uploads/2023/04/22220618/hzG267lIBvu26K6pTKVCdPmtp9HVKX1JD08By9XvTWd3DDHbts-1500x1500.jpg",
              fit: BoxFit.cover,
              height: 200,
            ),
            const SizedBox(height: 20,),
            const Text(
              "Your meeting is ready",
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
                child: const ListTile(
                  leading: Icon(Icons.link),
                  title: SelectableText(
                    "bosadike-bache",
                    style: TextStyle(
                      fontWeight: FontWeight.w300
                    )
                  ),
                  trailing: Icon(Icons.copy),
                )
              ),
            ),
            Divider(thickness: 1,height: 40,indent: 20,endIndent: 20,),
            
            Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: ElevatedButton.icon(
              onPressed: (){}, 
              // ignore: prefer_const_constructors
              icon: Icon(Icons.arrow_drop_down,color: Colors.white) ,
              // ignore: prefer_const_constructors
              label: Text("Share Invite",style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                fixedSize: Size(325,30),
              )
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.fromLTRB(10,0,0,0),
            child: OutlinedButton.icon(
              onPressed: (){},
              icon: Icon(Icons.video_call,color: Colors.indigo,),
              label: const Text("Start Call",style: TextStyle(color: Colors.indigo),),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.indigo),
                fixedSize: Size(325,30),
              )
            ),
          ),
          ],
        ),
      )
    );
  }
}