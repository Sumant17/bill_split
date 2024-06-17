//events
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';

abstract class CreateGroupEvent {}

class OnDoneButtonClicked extends CreateGroupEvent {
  final String name;
  final String imagepath;
  OnDoneButtonClicked({required this.name, required this.imagepath});
}

class OnGroupPicClicked extends CreateGroupEvent {
  final String imagepath;
  OnGroupPicClicked({required this.imagepath});
}

//states
abstract class CreateGroupState {}

class InitialGroupState extends CreateGroupState {}

class Loading extends CreateGroupState {}

class GroupPicShow extends CreateGroupState {
  final String imagepath;
  GroupPicShow({required this.imagepath});

  //for hydrated bloc
  factory GroupPicShow.fromJson(Map<String, dynamic> json) {
    return GroupPicShow(imagepath: json['imagepath'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "imagepath": imagepath,
    };
  }
}

class CreateGroupSuccessState extends CreateGroupState {
  final String name;
  final String imagepath;
  CreateGroupSuccessState({required this.name, required this.imagepath});

  factory CreateGroupSuccessState.fromJson(Map<String, dynamic> json) {
    return CreateGroupSuccessState(
        name: json['name'] as String, imagepath: json['imagepath'] as String);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "imagepath": imagepath};
  }
}

//bloc
class CreateGroupBloc extends HydratedBloc<CreateGroupEvent, CreateGroupState> {
  late String _imagepath = '';

  CreateGroupBloc() : super(InitialGroupState()) {
    on<OnGroupPicClicked>((event, emit) async {
      final picker = ImagePicker();
      final pickedfile = await picker.pickImage(source: ImageSource.camera);
      if (pickedfile != null) {
        _imagepath = pickedfile.path;
        emit(GroupPicShow(imagepath: pickedfile.path));
      }
    });

    on<OnDoneButtonClicked>((event, emit) {
      emit(CreateGroupSuccessState(
          name: event.name, imagepath: event.imagepath));
    });
  }

  //getters
  String get imagepath => _imagepath;

  @override
  CreateGroupState? fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('name') && json.containsKey('imagepath')) {
        return CreateGroupSuccessState.fromJson(json);
      } else if (json.containsKey('imagepath')) {
        return GroupPicShow.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      print('Error in serializing json : $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CreateGroupState state) {
    if (state is GroupPicShow) {
      return state.toJson();
    } else if (state is CreateGroupSuccessState) {
      return state.toJson();
    }
    return null;
  }
}
