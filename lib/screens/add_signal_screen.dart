import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_font_sizes.dart';
import '../models/signal_model.dart';
import '../repositories/signal_repository.dart';

class AddSignalScreen extends StatefulWidget {
  const AddSignalScreen({super.key});

  @override
  State<AddSignalScreen> createState() => _AddSignalScreenState();
}

class _AddSignalScreenState extends State<AddSignalScreen> {
  final _formKey = GlobalKey<FormState>();
  final SignalRepository _repository = SignalRepository();

  final TextEditingController _pairController = TextEditingController();
  final TextEditingController _leverageController = TextEditingController(
    text: '10x',
  );
  final TextEditingController _stopLossController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<TextEditingController> _entryControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> _tpControllers = [TextEditingController()];

  String _selectedType = 'Futures'; // 'Futures' or 'Spot'
  String _selectedSide = 'LONG'; // 'LONG' or 'SHORT'
  bool _isLoading = false;

  @override
  void dispose() {
    _pairController.dispose();
    _leverageController.dispose();
    _stopLossController.dispose();
    _notesController.dispose();
    for (var c in _entryControllers) {
      c.dispose();
    }
    for (var c in _tpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addEntryTarget() {
    if (_entryControllers.length < 5) {
      setState(() {
        _entryControllers.add(TextEditingController());
      });
    }
  }

  void _removeEntryTarget(int index) {
    if (_entryControllers.length > 1) {
      setState(() {
        _entryControllers[index].dispose();
        _entryControllers.removeAt(index);
      });
    }
  }

  void _addTpTarget() {
    if (_tpControllers.length < 6) {
      setState(() {
        _tpControllers.add(TextEditingController());
      });
    }
  }

  void _removeTpTarget(int index) {
    if (_tpControllers.length > 1) {
      setState(() {
        _tpControllers[index].dispose();
        _tpControllers.removeAt(index);
      });
    }
  }

  Future<void> _submitSignal() async {
    if (!_formKey.currentState!.validate()) return;

    final entryTargets = _entryControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final tpTargets = _tpControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (entryTargets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal masukkan 1 Entry Price'),
          backgroundColor: AppColors.webRed,
        ),
      );
      return;
    }

    if (tpTargets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal masukkan 1 Take Profit (TP)'),
          backgroundColor: AppColors.webRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final pair = _pairController.text.trim().toUpperCase();
      final SignalModel newSignal = await _repository.createSignal(
        pair: pair,
        type: _selectedType,
        side: _selectedSide,
        leverage: _selectedType == 'Futures'
            ? _leverageController.text.trim()
            : null,
        entryTargets: entryTargets,
        tpTargets: tpTargets,
        stopLoss: _stopLossController.text.trim().isNotEmpty
            ? _stopLossController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sinyal ${newSignal.pair} berhasil dibuat!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.webRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tambah Sinyal',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSizes.lg,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pair (e.g. BTC/USDT)
              _buildLabel('Trading Pair *'),
              TextFormField(
                controller: _pairController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textCapitalization: TextCapitalization.characters,
                decoration: _inputDecoration(
                  hintText: 'BTC/USDT...',
                  prefixIcon: const Icon(
                    Icons.currency_exchange,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Pair tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Type (Futures / Spot)
              _buildLabel('Pasar *'),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableButton(
                      label: 'Futures',
                      isSelected: _selectedType == 'Futures',
                      onTap: () => setState(() => _selectedType = 'Futures'),
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSelectableButton(
                      label: 'Spot',
                      isSelected: _selectedType == 'Spot',
                      onTap: () => setState(() => _selectedType = 'Spot'),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Position Side (LONG / SHORT)
              _buildLabel('Posisi *'),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableButton(
                      label: 'LONG',
                      isSelected: _selectedSide == 'LONG',
                      onTap: () => setState(() => _selectedSide = 'LONG'),
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSelectableButton(
                      label: 'SHORT',
                      isSelected: _selectedSide == 'SHORT',
                      onTap: () => setState(() => _selectedSide = 'SHORT'),
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Leverage (Only for Futures)
              if (_selectedType == 'Futures') ...[
                _buildLabel('Leverage'),
                TextFormField(
                  controller: _leverageController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  decoration: _inputDecoration(
                    hintText: 'Contoh: 10x, 20x, 50x',
                    prefixIcon: const Icon(
                      Icons.speed,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Entry Targets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Harga Entry *'),
                  if (_entryControllers.length < 5)
                    GestureDetector(
                      onTap: _addEntryTarget,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Tambah Entry',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              ...List.generate(_entryControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _entryControllers[index],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'Harga Entry ${index + 1}',
                          ),
                          validator: (val) {
                            if (index == 0 &&
                                (val == null || val.trim().isEmpty)) {
                              return 'Entry 1 wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_entryControllers.length > 1) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          onPressed: () => _removeEntryTarget(index),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 14),

              // Take Profit (TP) Targets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Take Profit *'),
                  if (_tpControllers.length < 6)
                    GestureDetector(
                      onTap: _addTpTarget,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.greenAccent,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Tambah TP',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              ...List.generate(_tpControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _tpControllers[index],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'Take Profit ${index + 1}',
                          ),
                          validator: (val) {
                            if (index == 0 &&
                                (val == null || val.trim().isEmpty)) {
                              return 'TP 1 wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_tpControllers.length > 1) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                          onPressed: () => _removeTpTarget(index),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 14),

              // Stop Loss
              _buildLabel('Stop Loss'),
              TextFormField(
                controller: _stopLossController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                decoration: _inputDecoration(
                  hintText: 'Tentukan batas kerugian...',
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _submitSignal,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Broadcast Sinyal',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textWhite70,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSelectableButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : AppColors.textWhite70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textWhite54, fontSize: 13),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColors.cardDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
