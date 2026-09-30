import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/place.dart';
import '../../providers/hive_provider.dart';

/// Punkt 11 (obowiązkowy): formularz z walidacją (pole tekstowe, wybór oceny).
class AddNoteScreen extends ConsumerStatefulWidget {
  final String placeId;
  final String placeName;
  final double lat;
  final double lon;
  final String? category;

  const AddNoteScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    required this.lat,
    required this.lon,
    this.category,
  });

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  int _rating = 3;
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final repo = ref.read(placesLocalRepositoryProvider);
    final place = Place(
      id: widget.placeId,
      name: widget.placeName,
      lat: widget.lat,
      lon: widget.lon,
      category: widget.category,
    );
    await repo.saveOrUpdate(place, note: _noteController.text.trim(), rating: _rating);

    if (!mounted) return;
    setState(() => _saving = false);

    // pop - wraca do poprzedniego ekranu po zapisaniu
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_note'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.placeName, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'note_label'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'note_required'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text('rating_label'.tr(), style: Theme.of(context).textTheme.titleSmall),
              Row(
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  return IconButton(
                    icon: Icon(
                      starValue <= _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => _rating = starValue),
                  );
                }),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('save'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
