import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.support_agent),
      onPressed: () => _showSupportDialog(context),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Continue to Support'),
          content:
              Text('Would you like to chat with our support team on WhatsApp?'),
          actions: <Widget>[
            FloatingActionButton(
              child: FaIcon(FontAwesomeIcons.whatsapp),
              backgroundColor: Colors.green.shade800,
              onPressed: () => _launchWhatsApp(context),
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _launchWhatsApp(BuildContext context) async {
// TODO Ori change it to correct link
    final Uri whatsappUri =
        Uri.parse("https://wa.me/${dotenv.get("WHATSAPP_PHONE_NUMBER")}");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open WhatsApp')),
      );
    }
  }
}
