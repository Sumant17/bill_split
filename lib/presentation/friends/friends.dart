import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/friends/friends_bloc.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          BlocConsumer<FriendsBloc, FriendsListState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is InitialLoadFriendsList) {
                if (state.friends.isEmpty) {
                  return const Center(
                    child: Column(
                      children: [
                        Center(
                          child: Text('No Friends added yet!'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text('Add a friend when creating groups!!!'),
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
    );
  }
}
