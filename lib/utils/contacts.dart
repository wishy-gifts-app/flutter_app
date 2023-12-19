import 'package:Wishy/models/Follower.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import "package:Wishy/services/save_followers.dart";

class Contacts {
  static bool permissionGranted = false;
  static List<Contact> allContacts = [];

  static Future<void> permissionHandler() async {
    if (!Contacts.permissionGranted)
      Contacts.permissionGranted =
          await FlutterContacts.requestPermission(readonly: true);
  }

  static Future<List<Follower>?> searchContacts(String term) async {
    await Contacts.permissionHandler();

    if (!Contacts.permissionGranted) return null;

    if (Contacts.allContacts.length == 0)
      Contacts.allContacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: false,
        withPhoto: false,
        withGroups: false,
        withAccounts: false,
        sorted: true,
        deduplicateProperties: true,
      );

    List<Contact> filteredContacts = Contacts.allContacts.where((contact) {
      return contact.displayName.toLowerCase().contains(term.toLowerCase());
    }).toList();

    final s = filteredContacts.map((e) {
      print(e.displayName);
      print(e.phones);

      return Follower(
          name: e.displayName,
          phoneNumber: e.phones.isNotEmpty ? e.phones[0].number : "");
    }).toList();
    return s;
  }

  static Future<void> fetchAndSaveContacts() async {
    await Contacts.permissionHandler();

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
}
