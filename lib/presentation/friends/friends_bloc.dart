//events
import 'package:hydrated_bloc/hydrated_bloc.dart';
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

  factory InitialLoadFriendsList.fromJson(Map<String, dynamic> json) {
    return InitialLoadFriendsList(
        friends: (json['friends'] as List)
            .map((friend) => FriendsListModel.fromJson(friend))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'friends': friends.map((friend) => friend.toJson()).toList(),
    };
  }
}

class LoadingState extends FriendsListState {}

//bloc
class FriendsBloc extends HydratedBloc<FriendsListEvent, FriendsListState> {
  FriendsBloc() : super(LoadingState()) {
    on<OnInitialLoadFriends>((event, emit) {
      final storedfriends =
          fromJson(HydratedBloc.storage.read('FriendsBloc') ?? {});
      if (storedfriends != null) {
        emit(storedfriends);
      } else {
        emit(InitialLoadFriendsList(friends: []));
      }
    });

    on<OnAddFriends>((event, emit) {
      final currentstate = state as InitialLoadFriendsList;
      final friend = currentstate.friends;
      final newfriend = FriendsListModel(friendname: event.friend);
      emit(InitialLoadFriendsList(friends: [newfriend, ...friend]));
    });
  }

  @override
  FriendsListState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['friends'] != null) {
        return InitialLoadFriendsList.fromJson(json);
      }
    } catch (e) {
      print('Error : $e');
    }

    return null;
  }

  @override
  Map<String, dynamic>? toJson(FriendsListState state) {
    if (state is InitialLoadFriendsList) {
      return state.toJson();
    }
    return null;
  }
}
