import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WebViewApp(),
  ));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  // HTML код страницы (эмуляция вашего сайта)
  final String htmlContent = '''<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
<style>
body{background:#121212;color:white;display:flex;flex-direction:column;height:100vh;justify-content:center;align-items:center;font-family:sans-serif;margin:0}
.btn{width:100px;height:100px;background:#333;border:3px solid #fff;border-radius:50%;display:flex;justify-content:center;align-items:center;font-size:40px;cursor:pointer;box-shadow:0 5px 15px rgba(0,0,0,0.5)}
.btn:active{transform:scale(0.9);background:#555}
</style>
</head>
<body>
<h2>Фото профиля</h2>
<div class="btn" onclick="openCam()">📷</div>
<p style="color:#777;margin-top:20px">Нажми на камеру</p>
<script>
function openCam(){
  if(window.BowlmatesApp){
    window.BowlmatesApp.postMessage("OPEN_CAMERA");
  } else {
    alert("Нет связи с приложением");
  }
}
</script>
</body>
</html>''';

  @override
  void initState() {
    super.initState();
    
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF121212))
      // Регистрируем канал 'BowlmatesApp'
      ..addJavaScriptChannel(
        'BowlmatesApp',
        onMessageReceived: (JavaScriptMessage message) {
          // ЛОГИКА ОБРАБОТКИ СООБЩЕНИЙ
          if (message.message == 'OPEN_CAMERA') {
            _handleCameraAction();
          } else {
            debugPrint("Получено: ${message.message}");
          }
        },
      )
      ..loadHtmlString(htmlContent); // Загружаем HTML строку вместо URL
  }

  // Эмуляция открытия камеры во Flutter
  void _handleCameraAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.camera_alt, color: Colors.white),
            SizedBox(width: 10),
            Text('Flutter: Запускаю модуль камеры...'),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
        duration: const Duration(seconds: 2),
      ),
    );
    // Здесь обычно вызывается ImagePicker().pickImage(...)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
