import 'package:url_launcher/url_launcher.dart';

class BookingService {
  static Future<void> launchBooking(String appUrl, String webUrl) async {
    final Uri appUri = Uri.parse(appUrl);
    final Uri webUri = Uri.parse(webUrl);

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.platformDefault);
    }
  }
}
