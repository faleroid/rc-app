import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/app_colors.dart';

class YouTubeModulePlayer extends StatefulWidget {
  final String? videoId;
  final String? fallbackImageUrl;

  const YouTubeModulePlayer({
    super.key,
    required this.videoId,
    this.fallbackImageUrl,
  });

  @override
  State<YouTubeModulePlayer> createState() => _YouTubeModulePlayerState();
}

class _YouTubeModulePlayerState extends State<YouTubeModulePlayer> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    if (widget.videoId != null && widget.videoId!.isNotEmpty) {
      const String appOrigin = 'https://ricocapital.co.id';

      final String embedHtml =
          '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background-color: #000000; overflow: hidden; height: 100vh; width: 100vw; }
    .video-container { position: relative; width: 100%; height: 100%; }
    .video-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0; }
  </style>
</head>
<body>
  <div class="video-container">
    <!-- KUNCI 2: Pakai youtube-nocookie.com & tambahkan &origin= dan &enablejsapi=1 -->
    <iframe 
      src="https://www.youtube.com/embed/${widget.videoId}?autoplay=0&rel=0&modestbranding=1&playsinline=1&controls=1&enablejsapi=1&origin=$appOrigin" 
      frameborder="0" 
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
      allowfullscreen>
    </iframe>
  </div>
</body>
</html>
''';

      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        // ..setUserAgent(
        //   'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15',
        // )
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains('youtube.com/embed') ||
                  request.url.startsWith('about:blank') ||
                  request.url.startsWith('data:')) {
                return NavigationDecision.navigate;
              }
              return NavigationDecision.prevent;
            },
          ),
        )
        ..loadHtmlString(embedHtml, baseUrl: appOrigin);
    }
  }

  @override
  void didUpdateWidget(covariant YouTubeModulePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      if (widget.videoId != null && widget.videoId!.isNotEmpty) {
        _initWebViewController();
      } else {
        _webViewController = null;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoId == null ||
        widget.videoId!.isEmpty ||
        _webViewController == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          width: double.infinity,
          color: AppColors.cardDark,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.fallbackImageUrl != null &&
                  widget.fallbackImageUrl!.isNotEmpty)
                Image.network(
                  widget.fallbackImageUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              Container(color: Colors.black54),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: Colors.white54,
                    size: 56,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Video Modul Tidak Tersedia',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          // 1. PLAYER YOUTUBE / WEBVIEW DI LAPISAN PALING BAWAH
          WebViewWidget(controller: _webViewController!),

          // ─── SHIELD 1: BLOKIR AREA ATAS FULL (Judul Video & Profil Channel) ───
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 55,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                debugPrint("Klik area Judul/Atas diblokir!");
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          // ─── SHIELD 2: BLOKIR KHUSUS POJOK KANAN ATAS (Tombol Share & Tonton Nanti) ───
          Positioned(
            top: 0,
            right: 0,
            width: 140,
            height: 60,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                debugPrint("Klik tombol Share/Setting atas diblokir!");
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          // ─── SHIELD 3: BLOKIR LOGO YOUTUBE DI KANAN BAWAH ───
          Positioned(
            bottom: 0,
            right: 0,
            width: 110,
            height: 45,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                debugPrint("Klik logo YouTube diblokir!");
              },
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
