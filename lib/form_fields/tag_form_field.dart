// Adapted from Anuchit Chalothorn's tag_form_field library from pub.dev:
//
// Copyright (c) 2024 Anuchit Chalothorn
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Code in this file follows OUR license which should be included with the package.

import 'package:flutter/material.dart';

/// A form field widget for inputting and displaying tags.
///
/// This widget allows users to input tags as a comma-separated list
/// and displays them as chips. Users can also remove tags by tapping
/// on the delete icon in each chip.
class TagFormField extends StatefulWidget {
  /// Creates a [TagFormField].
  ///
  /// The [initialTags] parameter can be used to instantiate a list of
  /// tags you want to be in the input field.
  ///
  /// The [decoration] parameter can be used to customize the appearance
  /// of the input field.
  ///
  /// The [onValueChanged] callback is called whenever the list of tags
  /// is modified.
  const TagFormField({
    super.key,
    this.initialTags,
    this.decoration,
    this.onValueChanged,
  });

  /// A [List] of initial tags.
  final List<String>? initialTags;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// Called when the list of tags changes.
  final ValueChanged<List<String>>? onValueChanged;

  @override
  State<TagFormField> createState() => _TagFormFieldState();
}

class _TagFormFieldState extends State<TagFormField> {
  /// The list of current tags.
  final List<String> _tags = [];

  /// Controller for the text input field.
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    if (widget.initialTags != null) {
      for (var tag in widget.initialTags!) {
        _addTags(tag);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  /// Adds new tags from the input value.
  ///
  /// This method splits the input by commas, trims whitespace,
  /// removes duplicates, and adds new tags to the list.
  void _addTags(String value) {
    final newTags = value
        .split(',')
        .map((e) => e.trim())
        .where((tag) => tag.isNotEmpty && !_tags.contains(tag))
        .toList();

    if (newTags.isNotEmpty) {
      setState(() {
        _tags.addAll(newTags);
        _tagController.clear();
      });
      widget.onValueChanged?.call(_tags);
    }
  }

  /// Removes a tag at the specified index.
  void _removeTag(int index) {
    setState(() => _tags.removeAt(index));
    widget.onValueChanged?.call(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _tagController,
          decoration: widget.decoration,
          maxLines: 1,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            if (value.contains(',')) {
              _addTags(value);
            }
          },
        ),
        const SizedBox(height: 8.0),
        if (_tags.isNotEmpty)
          Wrap(
            children: _tags
                .asMap()
                .entries
                .map((entry) => _buildChip(entry.value, entry.key))
                .toList(),
          ),
      ],
    );
  }

  /// Builds a chip widget for a single tag.
  ///
  /// The chip includes the tag label and a delete button.
  Widget _buildChip(String label, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        deleteIcon: const Icon(Icons.remove_circle),
        onDeleted: () => _removeTag(index),
      ),
    );
  }
}
