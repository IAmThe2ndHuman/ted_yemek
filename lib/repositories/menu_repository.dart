import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// TODO: maybe add the List<String>? _favoriteDishes; thing here too
class MenuRepository {
  static final Uri menuUri = Uri.https("www.tedistanbul.com.tr", "/sofra/MobilHaftalik.aspx", {"school": "3"});
  static const String _cache = "cache.html";
  static const String _cacheExpr = "cache.html.expiration";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getMenuHtml() async {
    var now = DateTime.now();
    var cacheExpiration = (await _prefs).getInt(_cacheExpr); // EPOCH (MS)

    if (cacheExpiration != null && cacheExpiration > now.millisecondsSinceEpoch) {
      var htmlCache = (await _prefs).getString(_cache);
      if (htmlCache != null) return htmlCache;
    }

    var html = await _fetchMenuHtml();
    (await _prefs).setString(_cache, html);

    var expirationDate = DateTime(now.year, now.month, now.day).add(Duration(days: 8 - now.weekday));
    await (await _prefs).setInt("cache.html.expiration", expirationDate.millisecondsSinceEpoch);

    return html;
  }

  Future<void> clearCache() async {
    await (await _prefs).remove(_cacheExpr);
    await (await _prefs).remove(_cache);
  }

  Future<bool> get menuCacheValid async {
    var cacheExpiration = (await _prefs).getInt(_cacheExpr);
    if (cacheExpiration == null) return false;

    var now = DateTime.now();

    return cacheExpiration > now.millisecondsSinceEpoch;
  }

  static Future<String> _fetchMenuHtml() async {
    var response = await http.get(menuUri);
    return response.body;

    // return html; // todo dev
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
