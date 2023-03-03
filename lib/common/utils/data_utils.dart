import '../const/data.dart';

class DataUtils {
  static String pathConcatThumbUrl(String thumbUrl) {
    return 'http://$baseIp:$basePort$thumbUrl';
  }

  static List<String> listPathsToUrls(List<String> paths) {
    return paths.map((e) => pathConcatThumbUrl(e)).toList();
  }
}
