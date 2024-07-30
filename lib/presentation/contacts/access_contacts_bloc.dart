import 'package:fast_contacts/fast_contacts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_app/models/groups_model.dart';
import 'package:my_app/utils/firebase_utils.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class ContactEvent {}

class InitialLoadContacts extends ContactEvent {}

class OnSelectContact extends ContactEvent {
  final Contact contact;
  OnSelectContact({required this.contact});
}

class OnCheckButtonClicked extends ContactEvent {
  final String selectedcontactname;
  OnCheckButtonClicked({required this.selectedcontactname});
}

abstract class ContactState {}

class ContactsInitial extends ContactState {}

class LoadingContacts extends ContactState {}

class Loading extends ContactState {}

class ContactsLoadSuccess extends ContactState {
  final List<Contact> contacts;

  ContactsLoadSuccess({required this.contacts});

  factory ContactsLoadSuccess.fromJson(Map<String, dynamic> json) {
    return ContactsLoadSuccess(
      contacts: (json['contacts'] as List)
          .map((contact) => Contact.fromMap(Map<String, dynamic>.from(contact)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contacts': contacts.map((contact) => contact.toMap()).toList(),
    };
  }
}

class ContactSelected extends ContactState {
  final Contact contact;
  ContactSelected({required this.contact});

  factory ContactSelected.fromJson(Map<String, dynamic> json) {
    return ContactSelected(
      contact: Contact.fromMap(Map<String, dynamic>.from(json['contact'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': contact.toMap(),
    };
  }
}

class ContactSelectSuccess extends ContactState {
  final String selectedcontactname;
  ContactSelectSuccess({required this.selectedcontactname});

  factory ContactSelectSuccess.fromJson(Map<String, dynamic> json) {
    return ContactSelectSuccess(
      selectedcontactname: json['selectedcontactname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedcontactname': selectedcontactname,
    };
  }
}

class ContactBloc extends HydratedBloc<ContactEvent, ContactState> {
  bool isLoading = false;
  final String groupname;
  ContactBloc({required this.groupname}) : super(ContactsInitial()) {
    on<InitialLoadContacts>((event, emit) async {
      // final storedcontactname =
      //     fromJson(HydratedBloc.storage.read('ContactBloc') ?? {});
      // if (storedcontactname != null) {
      //   emit(storedcontactname);
      //   return;
      // }
      // Permission handling
      if (await Permission.contacts.isGranted) {
        emit(LoadingContacts());
        try {
          final contacts = await FastContacts.getAllContacts();
          emit(ContactsLoadSuccess(contacts: contacts));
        } catch (e) {
          throw Exception(e);
        }
      } else {
        final status = await Permission.contacts.request();
        if (status == PermissionStatus.granted) {
          emit(LoadingContacts());
          try {
            final contacts = await FastContacts.getAllContacts();
            emit(ContactsLoadSuccess(contacts: contacts));
          } catch (e) {
            throw Exception(e);
          }
        } else {
          throw Exception('Contact access permission denied');
        }
      }
    });

    on<OnSelectContact>((event, emit) {
      emit(ContactSelected(contact: event.contact));
    });

    on<OnCheckButtonClicked>((event, emit) async {
      isLoading = true;
      emit(Loading());
      try {
        final GroupDetail = GroupsModel(
            groupname: groupname,
            imagepath: '',
            names: [event.selectedcontactname]);

        await FirebaseUtils.uploadgroupdetails(GroupDetail);
        emit(ContactSelectSuccess(
            selectedcontactname: event.selectedcontactname));
        isLoading = false;
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  ContactState? fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('contacts')) {
        return ContactsLoadSuccess.fromJson(Map<String, dynamic>.from(json));
      } else if (json.containsKey('contact')) {
        return ContactSelected.fromJson(Map<String, dynamic>.from(json));
      } else if (json.containsKey('selectedcontactname')) {
        return ContactSelectSuccess.fromJson(Map<String, dynamic>.from(json));
      }
      return null;
    } catch (e) {
      print('Error deserializing JSON: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ContactState state) {
    if (state is ContactsLoadSuccess) {
      return state.toJson();
    } else if (state is ContactSelected) {
      return state.toJson();
    } else if (state is ContactSelectSuccess) {
      return state.toJson();
    }
    return null;
  }
}
