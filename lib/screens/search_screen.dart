import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;


  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: width < webScreenSize ?  const EdgeInsets.all(0.0) : EdgeInsets.symmetric(horizontal : width / 3),
      child: Scaffold(
        appBar: isShowUsers ?
        AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Row(
            children: [
              IconButton(
                onPressed: (){
                  _searchController.clear();
                  setState(() {
                  isShowUsers = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      hintText: 'Search for a user',
                      hintStyle: const TextStyle(color: secondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(148, 148, 148, 0.5),
                    ),
                    style: const TextStyle(color: primaryColor),
                    onFieldSubmitted: (String _) {
                      setState(() {
                        isShowUsers = true;
                      });
                    },
                  ),
                ),
              ),
            ],

          ),
        ) :
        AppBar(
          title: SizedBox(
            height: 40,
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                hintText: 'Search for a user',
                hintStyle: const TextStyle(color: secondaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: const Color.fromRGBO(148, 148, 148, 0.5),
              ),
              style: const TextStyle(color: primaryColor),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
          ),
          backgroundColor: mobileBackgroundColor,
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('user')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, int index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid']))),
                        child: ListTile(
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ['photoUrl']),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 3,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                        fit: BoxFit.cover,
                      ),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
