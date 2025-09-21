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

import '../../l10n/app_localizations.dart';

/// A form field widget for inputting and displaying tags.
///
/// This widget allows users to input tags as a comma-separated list
/// and displays them as chips. Users can also remove tags by tapping
/// on the delete icon in each chip.
class ListFormField extends StatefulWidget {
  /// Creates a [ListFormField].
  ///
  /// The [initialList] parameter can be used to instantiate a list of
  /// strings that you want to be input already.
  ///
  /// The [decoration] parameter can be used to customize the appearance
  /// of the input field.
  ///
  /// The [onValueChanged] callback is called whenever the list is modified.
  const ListFormField({
    super.key,
    this.initialList,
    this.decoration,
    this.onValueChanged,
    required this.validate,
  });

  /// A [List] of initial tags.
  final List<String>? initialList;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// Called when the list of tags changes.
  final ValueChanged<List<String>>? onValueChanged;

  /// A check ran on every entry trying to be entered into the list.
  /// If `false` is returned, the entry wont enter the list.
  ///
  /// The calling method always checks for empty and duplicate entries first,
  /// you don't need to implement that yourself.
  final bool Function(String value) validate;

  @override
  State<ListFormField> createState() => _ListFormFieldState();
}

class _ListFormFieldState extends State<ListFormField> {
  /// The current list.
  final List<String> _entries = [];

  /// Controller for the text input field.
  final TextEditingController _entryController = TextEditingController();

  @override
  void initState() {
    if (widget.initialList != null) {
      for (var entry in widget.initialList!) {
        _addEntries(entry);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  /// Adds new entries from the input value.
  ///
  /// This method splits the input by commas, trims whitespace,
  /// removes duplicates, and adds new entries to the list.
  bool _addEntries(String value) {
    final newEntries = value
        .split(',')
        .map((e) => e.trim())
        // .where((tag) => tag.isNotEmpty && !_entries.contains(tag) && widget.validator(tag))
        .where((tag) => tag.isNotEmpty && !_entries.contains(tag))
        .toList();

    if (newEntries.isNotEmpty) {
      setState(() {
        _entries.addAll(newEntries);
        _entryController.clear();
      });
      widget.onValueChanged?.call(_entries);
    } else {
      return false;
    }
    return true;
  }

  /// Removes an entry at the specified index.
  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
    widget.onValueChanged?.call(_entries);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _entryController,
          decoration: widget.decoration,
          maxLines: 1,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            if (value.contains(',')) {
              _addEntries(value);
            }
          },
        ),
        const SizedBox(height: 8.0),
        if (_entries.isNotEmpty)
          Wrap(
            children: _entries
                .asMap()
                .entries
                .map((entry) => _buildEntryWidget(entry.value, entry.key))
                .toList(),
          ),
      ],
    );
  }

  /// Builds a [Container] with a [Dismissible] to display a single entry.
  Widget _buildEntryWidget(String label, int index) {
    var l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
      child: Dismissible(
        key: ValueKey<String>(_entries[index]),
        direction: DismissDirection.startToEnd,
        background: Container(color: Colors.red),
        onDismissed: (direction) => _removeEntry(index),
        child: widget.validate(label)
            ? ListTile(
                title: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(l10n.hint_swipe_to_remove),
                dense: true,
                tileColor: Theme.of(context).colorScheme.inversePrimary,
              )
            : ListTile(
                title: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                leading: Icon(Icons.error_outline),
                trailing: Text("${l10n.error_invalid} ${l10n.hint_swipe_to_remove}"),
                // dense: true,
                tileColor: Theme.of(context).colorScheme.errorContainer,
              ),
      ),
    );
  }
}
