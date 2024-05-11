import 'dart:io';

import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreen();
  }
}

class _AddPlaceScreen extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;

  var _enteredTitle = '';

  var _isSending = false;

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image.'),
        ),
      );
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(_enteredTitle, _selectedFile!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text('Title')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 100) {
                    return 'Must be 1 and 100 characters';
                  }
                  return null;
                },
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                onSaved: (value) {
                  _enteredTitle = value!;
                },
              ),
              const SizedBox(height: 10),
              ImageInput(
                onPickImage: (image) {
                  _selectedFile = image;
                },
              ),
              const SizedBox(height: 10),
              LocationInput(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isSending ? null : _savePlace,
                icon: const Icon(Icons.add),
                label: _isSending
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Add place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
