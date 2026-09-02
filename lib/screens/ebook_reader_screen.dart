import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';
import '../models/ebook_model.dart';
import '../repositories/ebook_repository.dart';

class EbookReaderScreen extends StatefulWidget {
  final String slug;
  final EbookModel? ebook;

  const EbookReaderScreen({super.key, required this.slug, this.ebook});

  @override
  State<EbookReaderScreen> createState() => _EbookReaderScreenState();
}

class _EbookReaderScreenState extends State<EbookReaderScreen> {
  final EbookRepository _repository = EbookRepository();
  WebViewController? _webViewController;

  bool _isLoading = true;
  bool _isPageLoading = true;
  String? _errorMessage;
  String? _pdfUrl;

  @override
  void initState() {
    super.initState();
    _fetchReaderUrl();
  }

  Future<void> _fetchReaderUrl() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = await _repository.fetchEbookReadUrl(widget.slug);
      if (mounted) {
        setState(() {
          _pdfUrl = url;
          _isLoading = false;
        });
        _initWebView(url);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _initWebView(String pdfUrl) {
    // If it's a PDF link, load via Google Docs embed viewer or Mozilla viewer with custom mobile UA
    final String encodedUrl = Uri.encodeComponent(pdfUrl);
    final String viewableUrl =
        pdfUrl.toLowerCase().contains('.pdf') || pdfUrl.contains('/storage/')
        ? 'https://docs.google.com/gview?embedded=true&url=$encodedUrl'
        : pdfUrl;

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      )
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isPageLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isPageLoading = false);
          },
          onWebResourceError: (error) {
            if (mounted) setState(() => _isPageLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(viewableUrl));
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.ebook?.title ?? 'Pembaca E-Book';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardDark,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w500,
            fontSize: AppFontSizes.lg,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textWhite,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.webRed),
                  SizedBox(height: 16),
                  Text(
                    'Tunggu sebentar yaaa :D',
                    style: TextStyle(
                      color: AppColors.textWhite70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.webRed,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textWhite),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.webRed,
                      ),
                      onPressed: _fetchReaderUrl,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                if (_webViewController != null)
                  WebViewWidget(controller: _webViewController!),

                if (_isPageLoading)
                  Container(
                    color: AppColors.background,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.webRed),
                          SizedBox(height: 12),
                          Text(
                            'Yeay, hampir selesai nih...',
                            style: TextStyle(
                              color: AppColors.textWhite70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
