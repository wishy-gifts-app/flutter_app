import 'package:flutter_contacts/flutter_contacts.dart';
import "package:Wishy/services/save_followers.dart";

Future<void> fetchContacts() async {
  bool permissionGranted =
      await FlutterContacts.requestPermission(readonly: true);

  if (permissionGranted) {
    // Start fetching contacts and saving them without waiting for completion
    _fetchAndSaveContacts();
  }
}

Future<void> _fetchAndSaveContacts() async {
  List<Contact> contacts =
      await FlutterContacts.getContacts(withProperties: true);
  final List<Map<String, String>> followers = [];

  for (var element in contacts) {
    if (element.phones.isNotEmpty &&
        element.phones[0].normalizedNumber.isNotEmpty) {
      followers.add({
        "phone_number": element.phones[0].number,
        "name": element.displayName
      });
    }
  }

  saveFollowers(followers);
}
