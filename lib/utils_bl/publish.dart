import 'package:http/http.dart' as http;
import '../constants/api_url.dart';
import '../constants/api_key.dart';
import 'dart:convert';

Future<bool> publishAd(String brand, String model, String year, String price, String region, String description, List<String> images) async {
  final response = await http.post(
    Uri.parse('$API_URL/post/publish.php?q=publishAd&user=${API_KEY}'),
    body: {
      'brand': brand,
      'about': description,
      'accounting': '0',
      'ad_type': 'Легковые',
      'avail': '1',
      'body': '0',
      'color': '0',
      'condition': '0',
      'customs': '0',
      'drive': '0',
      'engine': '0',
      'gen': '0',
      'img': json.encode(images),
      'jam': '0',
      'jam_type': '0',
      'model': model,
      'owners': '0',
      'pay_type': '0',
      'phone': '0',
      'phone2': '0',
      'price': price,
      'price_cur': '0',
      'region': region,
      'steering': '0',
      'transm': '0',
      'vin': '0',
      'volume': '0',
      'year': year,
    },
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

