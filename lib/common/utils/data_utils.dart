import '../const/data.dart';

class DataUtils {
  static pathConcatThumbUrl(String thumbUrl) {
    return 'http://$baseIp:$basePort$thumbUrl';
  }
}
