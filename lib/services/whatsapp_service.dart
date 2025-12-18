import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static const String supportPhoneNumber = '5599999999999';
  static const String defaultMessage = 'Olá, gostaria de falar com o Tree Scan.';

  static Future<void> openChat({
    String phoneNumber = supportPhoneNumber,
    String message = defaultMessage,
  }) async {
    final encodedMessage = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Não foi possível abrir o WhatsApp.');
    }
  }
}
