import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leejw/main.dart';

import '../../l10n/app_localizations.dart';

class StringWithLocaleFormField extends StatefulWidget {
  const StringWithLocaleFormField(
    this.initialValue,
    this.onValueChanged, {
    super.key,
  });

  final StringWithLocale? initialValue;
  final ValueChanged<StringWithLocale>? onValueChanged;

  @override
  State<StringWithLocaleFormField> createState() =>
      StringWithLocaleFormFieldState();
}

class StringWithLocaleFormFieldState extends State<StringWithLocaleFormField> {
  StringWithLocale? _currentValue;

  Widget _buildChip() {
    var l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
      child: Chip(
        label: Text(_currentValue?.value ?? l10n.generic_value),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        deleteIcon: Icon(Icons.edit),
        onDeleted: () => showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StringWithLocaleForm(
                  _currentValue,
                  (newValue) => setState(() {
                    _currentValue = newValue;
                    widget.onValueChanged?.call(_currentValue!);
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null)
      setState(() => _currentValue = widget.initialValue);

    return _buildChip();
  }
}

class StringWithLocaleListFormField extends StatefulWidget {
  const StringWithLocaleListFormField({
    super.key,
    required this.label,
    this.initialValues,
    this.onValueChanged,
    required this.validate,
  });

  final Widget label;
  final List<StringWithLocale>? initialValues;
  final ValueChanged<List<StringWithLocale>>? onValueChanged;
  final bool Function(StringWithLocale value) validate;

  @override
  State<StatefulWidget> createState() => _StringWithLocaleListFormFieldState();
}

class _StringWithLocaleListFormFieldState
    extends State<StringWithLocaleListFormField> {
  /// The current list.
  final List<StringWithLocale> _entries = [];

  @override
  void initState() {
    if (widget.initialValues != null) {
      for (var entry in widget.initialValues!) {
        setState(() => _entries.add(entry));
      }
    }
    super.initState();
  }

  void _add(StringWithLocale value) {
    setState(() => _entries.add(value));
    widget.onValueChanged?.call(_entries);
  }

  void _replace(StringWithLocale value, int index) {
    setState(() {
      _entries.removeAt(index);
      _entries.insert(index, value);
    });
  }

  void _remove(int index) {
    setState(() => _entries.removeAt(index));
    widget.onValueChanged?.call(_entries);
  }

  Widget _buildChip(StringWithLocale value, int index) {
    var string = value;
    return Container(
      margin: const EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
      child: Chip(
        label: GestureDetector(
          onLongPress: () {
            HapticFeedback.vibrate();
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StringWithLocaleForm(string, (newValue) {
                      _replace(newValue, index);
                      logger.t(
                        '${newValue.value} | ${newValue.locale.toLanguageTag()}',
                      );
                      string = newValue;
                    }),
                  ),
                );
              },
            );
          },
          child: Text('${string.value} | ${string.locale.toLanguageTag()}'),
        ),
        backgroundColor: widget.validate(string)
            ? Theme.of(context).colorScheme.inversePrimary
            : Theme.of(context).colorScheme.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        deleteIcon: const Icon(Icons.remove_circle),
        onDeleted: () => _remove(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 4.0, top: 4.0, bottom: 4.0),
          child: Chip(
            label: widget.label,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            deleteIcon: const Icon(Icons.add_circle),
            onDeleted: () => showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StringWithLocaleForm(
                      null,
                      (newValue) => setState(() => _add(newValue)),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // IconButton(
        //   onPressed: () => showDialog(
        //     context: context,
        //     builder: (context) {
        //       return Dialog(
        //         child: Padding(
        //           padding: const EdgeInsets.all(16.0),
        //           child: StringWithLocaleForm(
        //             null,
        //             (newValue) => setState(() => _add(newValue)),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        //   icon: Icon(Icons.add_circle),
        // ),
        if (_entries.isNotEmpty)
          for (var entry
              in _entries
                  .asMap()
                  .entries
                  .map((entry) => _buildChip(entry.value, entry.key))
                  .toList())
            entry,
      ],
    );
  }
}

// ignore: must_be_immutable
class StringWithLocaleForm extends StatefulWidget {
  StringWithLocaleForm(this.stringWithLocale, this.onSubmit, {super.key});

  StringWithLocale? stringWithLocale;
  final Function(StringWithLocale) onSubmit;

  @override
  State<StringWithLocaleForm> createState() => _StringWithLocaleFormState();
}

class _StringWithLocaleFormState extends State<StringWithLocaleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _valueController;
  TextEditingController? _localeController;

  @override
  void dispose() {
    _valueController?.dispose();
    _localeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _valueController = TextEditingController.fromValue(
      TextEditingValue(text: widget.stringWithLocale?.value ?? ''),
    );
    _localeController = TextEditingController.fromValue(
      TextEditingValue(
        text: widget.stringWithLocale?.locale.toLanguageTag() ?? '',
      ),
    );
    var l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _valueController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.generic_value,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.error_required(l10n.generic_field_this);
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _localeController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.generic_locale_example,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.error_required(l10n.generic_field_this);
              }
              try {
                Locale locale = Locale(value);
                if (locale.languageCode.isEmpty) {
                  return l10n.error_invalid_format(l10n.generic_locale);
                }
              } catch (e) {
                return l10n.error_invalid_format(l10n.generic_locale);
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.stringWithLocale = StringWithLocale(
                  _valueController!.text,
                  Locale(_localeController!.text),
                  -1,
                );
                Navigator.pop(context);
                widget.onSubmit(widget.stringWithLocale!);
              }
            },
            label: Text(l10n.action_confirm),
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class StringWithLocale {
  String value;
  Locale locale;
  int group;

  StringWithLocale(this.value, this.locale, this.group);
}
