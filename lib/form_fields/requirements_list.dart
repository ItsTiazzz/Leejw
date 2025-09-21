// Adapted from Anuchit Chalothorn's requirement_form_field library from pub.dev:
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

/// A form field widget for inputting and displaying requirements.
///
/// This widget allows users to input requirements as a comma-separated list
/// and displays them as chips. Users can also remove requirements by tapping
/// on the delete icon in each chip.
class RequirementsFormField extends StatefulWidget {
  /// Creates a [RequirementsFormField].
  ///
  /// The [initialRequirements] parameter can be used to instantiate a list of
  /// requirements you want to be in the input field.
  ///
  /// The [decoration] parameter can be used to customize the appearance
  /// of the input field.
  ///
  /// The [onValueChanged] callback is called whenever the list of requirements
  /// is modified.
  const RequirementsFormField({
    super.key,
    this.initialRequirements,
    this.decoration,
    this.onValueChanged,
  });

  /// A [List] of initial requirements.
  final List<Requirement>? initialRequirements;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// Called when the list of requirements changes.
  final ValueChanged<List<Requirement>>? onValueChanged;

  @override
  State<RequirementsFormField> createState() => _RequirementsFormFieldState();
}

class _RequirementsFormFieldState extends State<RequirementsFormField> {
  /// The list of current requirements.
  final List<Requirement> _requirements = [];

  /// Controller for the text input field.
  final TextEditingController _requirementController = TextEditingController();

  @override
  void initState() {
    if (widget.initialRequirements != null) {
      for (var requirement in widget.initialRequirements!) {
        _addRequirement(requirement);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _requirementController.dispose();
    super.dispose();
  }

  /// Adds new requirements from the input value.
  ///
  /// This method splits the input by commas, trims whitespace,
  /// removes duplicates, and adds new requirements to the list.
  void _addNewRequirements(String value) {
    final newRequirements = value
        .split(',')
        .map((e) => Requirement(e.trim(), null))
        .where(
          (requirement) =>
              requirement.value.isNotEmpty &&
              !_requirements.contains(requirement),
        )
        .toList();

    if (newRequirements.isNotEmpty) {
      setState(() {
        _requirements.addAll(newRequirements);
        _requirementController.clear();
      });
      widget.onValueChanged?.call(_requirements);
    }
  }

  /// Adds a single requirement to the list.
  /// This method is used internally to add initial requirements but
  /// can technically also be used if needed elsewhere.
  _addRequirement(Requirement requirement) {
    setState(() => _requirements.add(requirement));
    // widget.onValueChanged?.call(_requirements); // Gone because flutter doesn't like this during init
  }

  /// Removes a requirement at the specified index.
  void _removeRequirement(int index) {
    setState(() => _requirements.removeAt(index));
    widget.onValueChanged?.call(_requirements);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _requirementController,
          decoration: widget.decoration,
          maxLines: 1,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            if (value.contains(',')) {
              _addNewRequirements(value);
            }
          },
        ),
        const SizedBox(height: 8.0),
        if (_requirements.isNotEmpty)
          Column(
            children: _requirements
                .asMap()
                .entries
                .map((entry) => _buildChip(entry.value, entry.key))
                .toList(),
          ),
      ],
    );
  }

  /// Builds a chip widget for a single requirement.
  ///
  /// The chip includes the requirement label and a delete button.
  Widget _buildChip(Requirement requirement, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
      child: Chip(
        label: Row(
          children: [
            Text(requirement.value),
            // FUCK this shit bro I am so FUCKING done with this shit I'm gonna FUCKING kill a Google intern
            // Checkbox(
            //   value: requirement.required,
            //   onChanged: (value) {
            //     setState(() => requirement.required = value ?? true);
            //   },
            // )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        deleteIcon: const Icon(Icons.remove_circle),
        onDeleted: () => _removeRequirement(index),
      ),
    );
  }
}

class Requirement {
  final String value;
  bool? required;

  Requirement(this.value, this.required);
}
