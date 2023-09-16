import 'package:btc_rate/feature/common/bloc/selector_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final List<MapEntry<String, String>> options;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<String?>? onOptionChanged;
  final bool enabled;

  const CurrencyInput({
    super.key,
    required this.hint,
    required this.controller,
    required this.options,
    required this.onValueChanged,
    this.onOptionChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enableBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: theme.dividerColor.withOpacity(0.3),
      ),
    );
    return BlocProvider(
      create: (context) => SelectorBloc<String>()..select(options.first.key),
      child: Stack(
        children: [
          TextField(
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            enabled: enabled,
            controller: controller,
            onChanged: onValueChanged,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              enabledBorder: enableBorder,
              disabledBorder: enableBorder,
              contentPadding: const EdgeInsets.only(right: 76),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _getSymbol(context),
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 40,
                height: 24,
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            child: SizedBox(
              width: 60,
              child: _getDropdown(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSymbol(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return BlocBuilder<SelectorBloc<String>, String?>(
      builder: (context, state) {
        final option = options.firstWhereOrNull((item) {
          return item.key == state;
        });
        final symbol = option?.value ?? '';
        return Text(
          symbol,
          style: textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.dividerColor,
          ),
        );
      },
    );
  }

  Widget _getDropdown(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SelectorBloc<String>, String?>(
      builder: (context, state) {
        return DropdownButton<String>(
          underline: const SizedBox(),
          value: state ?? '',
          items: options.map((item) {
            return DropdownMenuItem(
              value: item.key,
              child: Text(
                item.key,
                style: theme.textTheme.bodyLarge,
              ),
            );
          }).toList(),
          icon: enabled ? null : const SizedBox(),
          onChanged: enabled
              ? (value) {
                  context.read<SelectorBloc<String>>().select(value);
                  onOptionChanged?.call(value);
                }
              : null,
        );
      },
    );
  }
}
