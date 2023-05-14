import 'package:shared_preferences/shared_preferences.dart';

class MenuRepository {
  static Future<String> getMenuHtml() async {
    var prefs = await SharedPreferences.getInstance();

    var now = DateTime.now();
    var cacheExpiration = prefs.getInt("htmlCache_expiration"); // EPOCH (MS)

    if (cacheExpiration != null && cacheExpiration > now.millisecondsSinceEpoch) {
      var htmlCache = prefs.getString("htmlCache");
      if (htmlCache != null) return htmlCache;
    }

    var html = await _fetchMenuHtml();
    await prefs.setString("htmlCache", html);

    var expirationDate = now
        .add(Duration(days: 7 - now.weekday))
        .subtract(Duration(hours: now.hour, minutes: now.minute, seconds: now.second, milliseconds: now.millisecond));
    await prefs.setInt("htmlCache_expiration", expirationDate.millisecondsSinceEpoch);

    return html;
  }

  static Future<String> _fetchMenuHtml() async {
    // var response = await http.get(Uri.https("www.tedistanbul.com.tr", "/sofra/MobilHaftalik.aspx", {"school": "3"}));
    // return response.body;
    return html; // todo dev
  }
}

const String html = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head><title>

</title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
    <link href="../ted2006.css" rel="stylesheet" type="text/css" /></head>
<body>
    <form name="form1" method="post" action="./MobilHaftalik.aspx?school=3" id="form1">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwULLTIwODA1MzUzNjdkZMIdZoHLllyUBG2Bt8JwuEbYbjPfM2zsOGgZgzICAG7t" />

<input type="hidden" name="__VIEWSTATEGENERATOR" id="__VIEWSTATEGENERATOR" value="B0D34A4C" />
    <table width="100%" border="0" cellpadding="2" cellspacing="2" align="center">
        <tr>
            <td class="balomavi">
         
                <span id="lblCaption">ORTAOKUL-LİSE HAFTALIK YEMEK MENÜSÜ</span>
             
            </td>
        </tr>
        <tr>
            <td class="TEXT" align="center">
                <div align="center">
                    
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    8 Mayıs 2023 Pazartesi
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong>
                                    <span id="lblPazartesi">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Tarhana Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kadınbudu Köfte
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Erişte
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Patlıcan Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Karnabahar
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Haşhaşpare
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    9 Mayıs 2023 Salı
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblSali">SABAH ATIŞTIRMASI</span> </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Ezogelin Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kıymalı Ispanak
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Su Böreği
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Mantar Pilaki
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kakaolu Şarlot
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kabak-Havuç Tarator
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    10 Mayıs 2023 Çarşamba
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblCarsamba">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Terbiyeli Havuç Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Köri Soslu Tavuk
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Bulgur Pilavı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Beyaz Lahana Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Kemalpaşa
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Patates Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Orbit Fasulye
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    11 Mayıs 2023 Perşembe
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblPersembe">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Etli Kuru Fasulye
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Pirinç Pilavı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Makarna Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Brokoli
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sütlü İrmik Tatlısı
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sebze Çorba
                            </td>
                        </tr>
                        
                    </table>
                    <table class="style1" align="center">
                        <tr>
                            <td>
                                <strong>
                                    12 Mayıs 2023 Cuma
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="tablokirmizi">
                                <strong><span id="lblCuma">SABAH ATIŞTIRMASI</span></strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablokirmizi">
                                <strong>ÖĞLE YEMEĞİ </strong>
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Brokoli Çorba
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Hamburger
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Patates Tava
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yeşil Salata
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Yoğurtlu Buğday Salatası
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Zeytinyağlı Enginar
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Meyve
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="tablo">
                                Sütlaç
                            </td>
                        </tr>
                        
                    </table>
                </div>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
""";

/*
get cache

if expr date present in cache
- if expr date passed
-- delete data, continue as normal then register new data in cache
- if expr not passed
-- return cached data
if expr date not present, continue as normal then register new data
 */
