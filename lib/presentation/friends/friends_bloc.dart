//events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/models/friends_list_model.dart';

abstract class FriendsListEvent {}

class OnInitialLoadFriends extends FriendsListEvent {}

class OnAddFriends extends FriendsListEvent {
  final String friend;

  OnAddFriends({required this.friend});
}

//states
abstract class FriendsListState {}

class InitialLoadFriendsList extends FriendsListState {
  final List<FriendsListModel> friends;
  InitialLoadFriendsList({required this.friends});
}

class LoadingState extends FriendsListState {}

//bloc
class FriendsBloc extends Bloc<FriendsListEvent, FriendsListState> {
  FriendsBloc() : super(LoadingState()) {
    on<OnInitialLoadFriends>((event, emit) {
      emit(InitialLoadFriendsList(friends: []));
    });

    on<OnAddFriends>((event, emit) {
      final currentstate = state as InitialLoadFriendsList;
      final friend = currentstate.friends;
      final newfriend = FriendsListModel(friendname: event.friend);
      emit(InitialLoadFriendsList(friends: [newfriend, ...friend]));
    });
  }
}
