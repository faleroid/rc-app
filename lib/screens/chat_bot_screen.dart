import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/font.dart';
import '../constants/margin.dart';
import '../models/chat_model.dart';
import '../repositories/chat_repository.dart';

class ChatBotScreen extends StatefulWidget {
  final int? courseId;
  final int? moduleId;
  final String? courseTitle;
  final String? moduleTitle;

  const ChatBotScreen({
    super.key,
    this.courseId,
    this.moduleId,
    this.courseTitle,
    this.moduleTitle,
  });

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final ChatRepository _repository = ChatRepository();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addInitialGreeting();
  }

  void _addInitialGreeting() {
    String greeting = 'Halo! Saya AI Asisten Pembelajaran RicoCapital. 👋\n\n'
        'Ada materi atau rumus trading yang ingin Anda tanyakan seputar modul ini?';
    if (widget.moduleTitle != null) {
      greeting = 'Halo! Saya AI Asisten Pembelajaran untuk modul "${widget.moduleTitle}". 👋\n\n'
          'Silakan ajukan pertanyaan seputar materi pada modul ini.';
    }

    _messages.add(ChatMessageModel.bot(text: greeting));
  }

  void _sendMessage([String? quickText]) async {
    final text = quickText ?? _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    if (quickText == null) {
      _textController.clear();
    }

    setState(() {
      _messages.add(ChatMessageModel.user(text));
      _isLoading = true;
    });

    _scrollToBottom();

    final botReply = await _repository.askQuestion(
      question: text,
      courseId: widget.courseId,
      moduleId: widget.moduleId,
    );

    if (mounted) {
      setState(() {
        _messages.add(botReply);
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardDark,
        elevation: 1,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Asisten Pembelajaran',
                    style: TextStyle(color: Colors.white, fontSize: AppFontSizes.md, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.courseTitle ?? 'RicoCapital Academy',
                    style: const TextStyle(color: AppColors.textWhite70, fontSize: AppFontSizes.xs),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            // Loading Indicator
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'AI sedang mencari materi...',
                            style: TextStyle(color: Colors.white70, fontSize: AppFontSizes.xs),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Sample Quick Prompts if messages are few
            if (_messages.length <= 2)
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    _buildQuickChip('Apa poin utama materi ini?'),
                    const SizedBox(width: 8),
                    _buildQuickChip('Rangkumkan penjelasan modul ini'),
                    const SizedBox(width: 8),
                    _buildQuickChip('Bagaimana strategi risk management?'),
                  ],
                ),
              ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.cardDark,
                border: Border(top: BorderSide(color: AppColors.cardBorder, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white, fontSize: AppFontSizes.sm),
                      decoration: InputDecoration(
                        hintText: 'Tanyakan materi kelas...',
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: AppFontSizes.sm),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isLoading ? null : () => _sendMessage(),
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      backgroundColor: AppColors.cardDark,
      side: const BorderSide(color: AppColors.cardBorder),
      onPressed: () => _sendMessage(label),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.cardDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser ? null : Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : (msg.isInScope ? Colors.white : Colors.white70),
                      fontSize: AppFontSizes.sm,
                      height: 1.4,
                    ),
                  ),
                  if (!isUser && msg.sources.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 6),
                    const Text(
                      '📌 Sumber Referensi Modul:',
                      style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ...msg.sources.map(
                      (src) => Text(
                        '• ${src.moduleTitle}',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.webRed,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
