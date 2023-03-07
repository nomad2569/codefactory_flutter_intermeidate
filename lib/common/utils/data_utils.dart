import 'dart:convert';

import '../const/data.dart';

class DataUtils {
  static String pathConcatThumbUrl(String thumbUrl) {
    return 'http://$baseIp:$basePort$thumbUrl';
  }

  // 들어오는 부분 dynamic type 으로 가정했다.
  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathConcatThumbUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}
