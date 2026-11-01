import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/profile/domain/entities/profile.dart';
import 'package:sportify/features/profile/presentation/cubit/profile_cubit.dart';

/// Opens the Edit Profile modal bottom sheet and saves via [ProfileCubit].
Future<void> showProfileEditSheet(BuildContext context, Profile profile) {
  final cubit = context.read<ProfileCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF0E1822),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _ProfileEditForm(profile: profile),
    ),
  );
}

class _ProfileEditForm extends StatefulWidget {
  const _ProfileEditForm({required this.profile});
  final Profile profile;

  @override
  State<_ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<_ProfileEditForm> {
  static const _bioLangs = ['EN', 'DE', 'AR'];
  static const _feet = ['Right', 'Left', 'Both'];

  late final TextEditingController _bioEnCtrl;
  late final TextEditingController _bioDeCtrl;
  late final TextEditingController _bioArCtrl;
  late final TextEditingController _positionCtrl;
  late final TextEditingController _nationalityCtrl;
  late final TextEditingController _heightCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _newVideoCtrl;

  String _selectedBioLang = 'EN';
  late String _selectedFoot;
  late bool _available;
  late List<String> _videoLinks;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _bioEnCtrl = TextEditingController(text: p.bio ?? '');
    _bioDeCtrl = TextEditingController(text: 'Offensiver Mittelfeldspieler mit starker Spielübersicht.');
    _bioArCtrl = TextEditingController(text: 'صانع ألعاب هجومي يتميز بالرؤية الميدانية والسرعة.');
    _positionCtrl = TextEditingController(text: p.position ?? 'Attacking Midfielder (CAM)');
    _nationalityCtrl = TextEditingController(text: p.nationality ?? 'Germany');
    _heightCtrl = TextEditingController(text: '${p.heightCm ?? 182}');
    _weightCtrl = TextEditingController(text: '${p.weightKg ?? 75}');
    _newVideoCtrl = TextEditingController();
    _selectedFoot = _feet.contains(p.preferredFoot) ? p.preferredFoot! : 'Right';
    _available = p.isAvailableForTransfer;
    _videoLinks = List<String>.of(p.videoLinks);
  }

  @override
  void dispose() {
    _bioEnCtrl.dispose();
    _bioDeCtrl.dispose();
    _bioArCtrl.dispose();
    _positionCtrl.dispose();
    _nationalityCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _newVideoCtrl.dispose();
    super.dispose();
  }

  TextEditingController get _activeBioCtrl => switch (_selectedBioLang) {
        'DE' => _bioDeCtrl,
        'AR' => _bioArCtrl,
        _ => _bioEnCtrl,
      };

  void _addVideoLink() {
    final v = _newVideoCtrl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      _videoLinks.add(v);
      _newVideoCtrl.clear();
    });
  }

  void _save() {
    final updated = widget.profile.copyWith(
      bio: _activeBioCtrl.text.trim(),
      position: _positionCtrl.text.trim(),
      nationality: _nationalityCtrl.text.trim(),
      preferredFoot: _selectedFoot,
      heightCm: int.tryParse(_heightCtrl.text.trim()) ?? widget.profile.heightCm ?? 180,
      weightKg: int.tryParse(_weightCtrl.text.trim()) ?? widget.profile.weightKg ?? 75,
      isAvailableForTransfer: _available,
      videoLinks: _videoLinks,
    );
    context.read<ProfileCubit>().updateProfile(updated);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Football CV & profile updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            const Text('Edit Football CV & Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),

            // ── 1. Multilingual Bio Switcher (EN / DE / AR) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Multilingual Bio', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                Row(
                  children: _bioLangs.map((lang) {
                    final sel = lang == _selectedBioLang;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedBioLang = lang),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: sel ? green : surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: sel ? green : border),
                          ),
                          child: Text(lang, style: TextStyle(color: sel ? Colors.black : Colors.white70, fontSize: 10.5, fontWeight: FontWeight.w900)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _Input(controller: _activeBioCtrl, hint: 'Write your scouting bio...', maxLines: 2),
            const SizedBox(height: 10),

            // ── 2. Position & Nationality ──
            Row(
              children: [
                Expanded(child: _LabeledInput(label: 'Position / Role', controller: _positionCtrl)),
                const SizedBox(width: 10),
                Expanded(child: _LabeledInput(label: 'Nationality', controller: _nationalityCtrl)),
              ],
            ),
            const SizedBox(height: 10),

            // ── 3. Height, Weight & Preferred Foot ──
            Row(
              children: [
                Expanded(child: _LabeledInput(label: 'Height (cm)', controller: _heightCtrl, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(child: _LabeledInput(label: 'Weight (kg)', controller: _weightCtrl, isNumber: true)),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Preferred Foot', style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Row(
              children: _feet.map((f) {
                final sel = f == _selectedFoot;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: f != _feet.last ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFoot = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: sel ? green.withValues(alpha: 0.16) : surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: sel ? green : border)),
                        child: Text(f, style: TextStyle(color: sel ? green : Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: green,
              value: _available,
              onChanged: (v) => setState(() => _available = v),
              title: const Text('Available for Transfer / Club Trials', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),

            // ── 4. Video Links (YouTube, Vimeo, TikTok, FB) ──
            const Text('Highlight Videos (YouTube, Vimeo, TikTok, FB)', style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            for (var i = 0; i < _videoLinks.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: border)),
                child: Row(children: [
                  const Icon(Icons.videocam_outlined, color: green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_videoLinks[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  GestureDetector(onTap: () => setState(() => _videoLinks.removeAt(i)), child: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 16)),
                ]),
              ),
            Row(children: [
              Expanded(child: _Input(controller: _newVideoCtrl, hint: 'Paste YouTube, Vimeo, or TikTok URL...')),
              const SizedBox(width: 8),
              IconButton.filled(onPressed: _addVideoLink, style: IconButton.styleFrom(backgroundColor: green, foregroundColor: Colors.black), icon: const Icon(Icons.add_rounded, size: 18)),
            ]),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity, height: 46,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Save Changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledInput extends StatelessWidget {
  const _LabeledInput({required this.label, required this.controller, this.isNumber = false});
  final String label;
  final TextEditingController controller;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        _Input(controller: controller, hint: label, isNumber: isNumber),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({required this.controller, required this.hint, this.maxLines = 1, this.isNumber = false});
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool isNumber;

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF13202E), border = Color(0xFF1B2A38);
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: border)),
      ),
    );
  }
}
