import 'package:animated_icon/animated_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../resources/auth_methods.dart';
import '../utils/global_variables.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance.collection('user').doc(widget.uid).get();
      //get post length
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get();
      postLength = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(widget.uid);
      setState(() {
      });
    }catch(e){
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading ?
        const Center(
          child: CircularProgressIndicator(),
        )
    :
    Padding(
      padding:width < webScreenSize ? const EdgeInsets.all(8.0) : EdgeInsets.symmetric(horizontal : width / 3),
      child: Scaffold(
        appBar:width < webScreenSize ? AppBar(
          centerTitle: false,
          title: Row(
            children: [
              Text(userData['username'],
              style: const TextStyle(
                  fontSize: 22,
                fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Icon(Icons.settings, size: 30,)
            ],
          ),
          backgroundColor: mobileBackgroundColor,
        ) : null,
        body: ListView(
          children: [
            Padding(
              padding:const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            userData['photoUrl']),
                      ),
                      Expanded(
                        flex:1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children:[
                                buildStatColumn("posts", postLength),
                                buildStatColumn("Followers", followers),
                                buildStatColumn("Following", following),
                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid == widget.uid ? Followbutton(
                                  text: "Sign out",
                                  function: () async {
                                    await AuthMethods().signOut();
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                                  },
                                  backgroundColor: mobileBackgroundColor,
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                ) : isFollowing ? Followbutton(
                                  text: "Unfollow",
                                  function: () async {
                                    FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid'], );
                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  },
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  borderColor: Colors.grey,
                                ) : Followbutton(
                                  text: "Follow",
                                  function: () async {
                                    FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid'], );
                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                  },
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  borderColor: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(
                      userData['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(
                      userData['bio'],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0 , vertical: 16.0),
              child: Divider(),
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return snapshot.data!.docs.isNotEmpty ?
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];
                      return Image.network(
                        snap['postUrl'],
                        fit: BoxFit.cover,
                      );
                    },
                  )
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AnimateIcon(
                          onTap: () {},
                          iconType: IconType.continueAnimation,
                          height: 70,
                          width: 100,
                          color: Colors.blue,
                          animateIcon: AnimateIcons.internet,
                        ),
                        const Text("No posts yet", style: TextStyle(color: Colors.grey, fontSize: 16),),
                        const Text("share your memories with the world", style: TextStyle(color: Colors.grey, fontSize: 16),),
                      ],
                    ),
                  )
                  ;
                }
            )
          ],
        ),
      ),
    );
  }

  Column buildStatColumn(String label, int num){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

}
