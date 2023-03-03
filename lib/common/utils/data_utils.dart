import '../const/data.dart';

class DataUtils {
  static String pathConcatThumbUrl(String thumbUrl) {
    return 'http://$baseIp:$basePort$thumbUrl';
  }

  // 들어오는 부분 dynamic type 으로 가정했다.
  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathConcatThumbUrl(e)).toList();
  }
}
