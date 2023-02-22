import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// Token 저장소 활성화
final storage = FlutterSecureStorage();

// 에뮬레이터를 사용한다면 localhost 의 IP 가 다름
final emulatorLocalIp = '10.0.2.2';
final simulatorLocalIp = '127.0.0.1';
final basePort = 3000;
final baseIp = Platform.isIOS ? simulatorLocalIp : emulatorLocalIp;
