import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/theme_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  String? _selectedLevel;
  bool _hasVisualImpairment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hoşgeldiniz')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Size en uygun deneyimi sunabilmemiz için lütfen aşağıdaki bilgileri doldurun.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Yaş',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Lütfen yaşınızı girin';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Görme Güçlüğü Var mı?'),
                value: _hasVisualImpairment,
                onChanged: (val) {
                  setState(() {
                    _hasVisualImpairment = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Kullanım Düzeyi',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'basic', child: Text('Temel (4x3)')),
                  DropdownMenuItem(value: 'intermediate', child: Text('Orta (5x4)')),
                  DropdownMenuItem(value: 'advanced', child: Text('İleri (6x6)')),
                ],
                onChanged: (val) => setState(() => _selectedLevel = val),
                validator: (val) => val == null ? 'Lütfen bir düzey seçin' : null,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _completeOnboarding,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Devam Et'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box(AppConstants.settingsBox);
      
      // Save Profile
      await box.put(AppConstants.userAgeKey, int.parse(_ageController.text));
      await box.put(AppConstants.userLevelKey, _selectedLevel);
      
      // Auto-Configure Theme
      bool highContrast = _hasVisualImpairment; 
      // Example logic: if Age > 65 assume high contrast might be needed
      if (int.parse(_ageController.text) > 65) highContrast = true;

      await ref.read(themeControllerProvider.notifier).setHighContrast(highContrast);
      if (highContrast) {
        await ref.read(themeControllerProvider.notifier).setFontSizeScale(1.2);
      }

      // Mark Onboarding as Done (using level key availability as flag or separate key)
      // For now, if level is set, we assume onboarding is done.
      
      if (mounted) {
        context.go('/');
      }
    }
  }
}
