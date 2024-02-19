import 'package:animated_icon/animated_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/widgets/post_card.dart';

import '../utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width < webScreenSize ? AppBar(
        backgroundColor: width < webScreenSize ? mobileBackgroundColor : webBackgroundColor,
        title : SvgPicture.asset('assets/images/ic_instagram.svg',
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          width: double.infinity,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.messenger_outline),
          ),
        ],
      ) : null,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length +1,
            itemBuilder: (BuildContext context, int index){
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: width > webScreenSize ? 15 : 0,
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                ),
                child: index != snapshot.data!.docs.length ?
                PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ) :
                Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Divider(),
                        )),
                        AnimateIcon(
                          onTap: () {},
                          iconType: IconType.continueAnimation,
                          height: 70,
                          width: 100,
                          color: Colors.pinkAccent,
                          animateIcon: AnimateIcons.checkmarkOk,
                        ),
                        const Expanded(child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Divider(),
                        )),
                      ],
                    ),
                    const Text("You're All Caught Up", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),
                    const Text("You've seen all the posts from last 2 days.", style: TextStyle(color: Colors.grey, fontSize: 12,),),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            },
          );
        },

      ),
    );
  }
}
