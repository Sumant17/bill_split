//events
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_app/models/groups_model.dart';

abstract class GroupEvent {}

class InitialLoadGroup extends GroupEvent {}

class CreateGroupList extends GroupEvent {
  final String groupname;
  final String groupimagepath;
  CreateGroupList({required this.groupname, required this.groupimagepath});
}

class UpdateGroupList extends GroupEvent {
  final String friend;
  UpdateGroupList({required this.friend});
}

//states
abstract class GroupState {}

class InitialLoaded extends GroupState {
  final List<GroupsModel> groups;
  InitialLoaded({required this.groups});

  //Serialization for hydarted bloc
  factory InitialLoaded.fromJson(Map<String, dynamic> json) {
    return InitialLoaded(
      groups: (json['groups'] as List)
          .map((group) => GroupsModel.fromJson(group))
          .toList(),
    );
  }

  //Deserialize
  Map<String, dynamic> toJson() {
    return {
      'groups': groups.map((group) => group.toJson()).toList(),
    };
  }
}

class Loading extends GroupState {}

//bloc
class GroupBloc extends HydratedBloc<GroupEvent, GroupState> {
  GroupBloc() : super(Loading()) {
    on<InitialLoadGroup>((event, emit) {
      final storeddata = fromJson(HydratedBloc.storage.read('GroupBloc') ??
          {}); //read data once app restarts
      if (storeddata != null) {
        emit(storeddata);
      } else {
        emit(InitialLoaded(groups: []));
      }
    });

    on<CreateGroupList>((event, emit) {
      final currentstate = state as InitialLoaded;
      final group = currentstate.groups;
      final newgroup = GroupsModel(
          groupname: event.groupname,
          imagepath: event.groupimagepath,
          names: []);

      emit(InitialLoaded(groups: [newgroup, ...group]));
    });

    on<UpdateGroupList>((event, emit) {
      final currentstate = state as InitialLoaded;
      final updatedgroups = currentstate.groups.map((group) {
        if (group.groupname == currentstate.groups.last.groupname) {
          final updatedname = List<String>.from(group.names);
          updatedname.add(event.friend);
          return GroupsModel(
              groupid: group.groupid,
              groupname: group.groupname,
              imagepath: group.imagepath,
              names: updatedname);
        }
        return group;
      }).toList();
      emit(InitialLoaded(groups: updatedgroups));
    });
  }

  @override
  GroupState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['groups'] != null) {
        return InitialLoaded.fromJson(json);
      }
    } catch (e) {
      print('Error deserializing Json : $e');
    }

    return null;
  }

  @override
  Map<String, dynamic>? toJson(GroupState state) {
    if (state is InitialLoaded) {
      return state.toJson();
    }
    return null;
  }
}
