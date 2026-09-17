import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';
import '../models/announcement_model.dart';
import '../repositories/announcement_repository.dart';

class AddAnnouncementScreen extends StatefulWidget {
  final AnnouncementModel? existingAnnouncement;

  const AddAnnouncementScreen({super.key, this.existingAnnouncement});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final AnnouncementRepository _repository = AnnouncementRepository();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _actionUrlController;
  late final TextEditingController _actionLabelController;

  String _selectedCategory = 'general';
  bool _isPinned = false;
  bool _isActive = true;
  bool _isLoading = false;

  XFile? _selectedImageFile;
  bool _removeCurrentImage = false;

  final List<Map<String, String>> _categories = [
    {'key': 'general', 'label': 'Umum'},
    {'key': 'info', 'label': 'Info'},
    {'key': 'event', 'label': 'Event'},
    {'key': 'urgent', 'label': 'Penting'},
  ];

  bool get _isEditing => widget.existingAnnouncement != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingAnnouncement;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _contentController = TextEditingController(text: existing?.content ?? '');
    _actionUrlController = TextEditingController(
      text: existing?.actionUrl ?? '',
    );
    _actionLabelController = TextEditingController(
      text: existing?.actionLabel ?? '',
    );

    if (existing != null) {
      _selectedCategory = existing.category;
      _isPinned = existing.isPinned;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _actionUrlController.dispose();
    _actionLabelController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImageFile = image;
          _removeCurrentImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImageFile = null;
      if (_isEditing) {
        _removeCurrentImage = true;
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isEditing) {
        await _repository.updateAnnouncement(
          id: widget.existingAnnouncement!.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: _selectedCategory,
          imagePath: _selectedImageFile?.path,
          removeImage: _removeCurrentImage,
          actionUrl: _actionUrlController.text.trim().isEmpty
              ? null
              : _actionUrlController.text.trim(),
          actionLabel: _actionLabelController.text.trim().isEmpty
              ? null
              : _actionLabelController.text.trim(),
          isPinned: _isPinned,
          isActive: _isActive,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text('Pengumuman berhasil diperbarui.'),
                ],
              ),
              backgroundColor: AppColors.cardDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.cardBorder, width: 0.5),
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        await _repository.createAnnouncement(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: _selectedCategory,
          imagePath: _selectedImageFile?.path,
          actionUrl: _actionUrlController.text.trim().isEmpty
              ? null
              : _actionUrlController.text.trim(),
          actionLabel: _actionLabelController.text.trim().isEmpty
              ? null
              : _actionLabelController.text.trim(),
          isPinned: _isPinned,
          isActive: _isActive,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text('Pengumuman baru berhasil dibuat.'),
                ],
              ),
              backgroundColor: AppColors.cardDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.cardBorder, width: 0.5),
              ),
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingImageUrl = widget.existingAnnouncement?.imageUrl;
    final showExistingImage =
        !_removeCurrentImage &&
        _selectedImageFile == null &&
        existingImageUrl != null &&
        existingImageUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit Pengumuman' : 'Tambah Pengumuman',
          style: const TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.lg,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Pengumuman
              _buildSectionLabel('Judul Pengumuman *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.md,
                ),
                decoration: _inputDecoration('Tulis Judul Pengumuman...'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Kategori
              _buildSectionLabel('Kategori *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat['key'];
                  return ChoiceChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat['key']!;
                        });
                      }
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.cardDark,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: AppFontSizes.sm,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.cardBorder,
                      width: 0.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Gambar Thumbnail (image_picker)
              _buildSectionLabel('Thumbnail'),
              const SizedBox(height: 8),
              if (_selectedImageFile != null) ...[
                // Display local selected image
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(_selectedImageFile!.path),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black87,
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _removeSelectedImage,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ] else if (showExistingImage) ...[
                // Display existing network image
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        existingImageUrl,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black87,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                      onPressed: _removeSelectedImage,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              OutlinedButton.icon(
                onPressed: _pickImage,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: AppColors.cardBorder,
                    width: 0.8,
                  ),
                  backgroundColor: AppColors.cardDark,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                label: Text(
                  _selectedImageFile != null || showExistingImage
                      ? 'Ganti Gambar'
                      : 'Pilih Gambar',
                  style: const TextStyle(fontSize: AppFontSizes.sm),
                ),
              ),
              const SizedBox(height: 18),

              // Isi Konten Pengumuman
              _buildSectionLabel('Isi Konten *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.sm,
                  height: 1.4,
                ),
                decoration: _inputDecoration(
                  'Tulis detail pengumuman di sini...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi konten wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Action URL (Opsional)
              _buildSectionLabel('Tautan Aksi (Opsional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _actionUrlController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.sm,
                ),
                decoration: _inputDecoration('https://...'),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 14),

              // Action Label (Opsional)
              _buildSectionLabel('Label Tombol Tautan (Opsional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _actionLabelController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.sm,
                ),
                decoration: _inputDecoration(
                  'Contoh: Buka Telegram / Daftar Sekarang',
                ),
              ),
              const SizedBox(height: 18),

              // Toggle Options
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder, width: 0.5),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      title: const Text(
                        'Sematkan Pengumuman',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSizes.sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text(
                        'Pengumuman akan muncul di posisi teratas',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: AppFontSizes.xs,
                        ),
                      ),
                      value: _isPinned,
                      trackOutlineColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: Colors.white60,
                      inactiveTrackColor: Colors.white12,
                      onChanged: (val) {
                        setState(() {
                          _isPinned = val;
                        });
                      },
                    ),
                    const Divider(
                      color: AppColors.cardBorder,
                      height: 1,
                      thickness: 0.5,
                    ),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      title: const Text(
                        'Status Aktif',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSizes.sm,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text(
                        'Tampilkan pengumuman ini kepada member',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: AppFontSizes.xs,
                        ),
                      ),
                      value: _isActive,
                      trackOutlineColor: const WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.primary,
                      inactiveThumbColor: Colors.white60,
                      inactiveTrackColor: Colors.white12,
                      onChanged: (val) {
                        setState(() {
                          _isActive = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isEditing ? 'Simpan Perubahan' : 'Publikasikan',
                          style: const TextStyle(
                            fontSize: AppFontSizes.md,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: AppFontSizes.sm,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white38,
        fontSize: AppFontSizes.sm,
      ),
      filled: true,
      fillColor: AppColors.cardDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cardBorder, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cardBorder, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1),
      ),
    );
  }
}
