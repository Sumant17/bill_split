import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/friends/friends_bloc.dart';
import 'package:my_app/widgets/my_background_color.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Friends',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: MyBackgroundColor(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            BlocConsumer<FriendsBloc, FriendsListState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is InitialLoadFriendsList) {
                  if (state.friends.isEmpty) {
                    return const Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Center(
                            child: Text(
                              'No Friends added yet!',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              'Add a friend when creating groups!!!',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.friends.length,
                        itemBuilder: (context, index) {
                          final friend = state.friends[index];
                          return ListTile(
                            leading: const Icon(Icons.phone),
                            title: Text(friend.friendname),
                          );
                        }),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
