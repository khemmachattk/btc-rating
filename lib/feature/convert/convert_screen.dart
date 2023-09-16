import 'package:btc_rate/feature/convert/convert_bloc.dart';
import 'package:btc_rate/feature/convert/convert_state.dart';
import 'package:btc_rate/feature/convert/widget/currency_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ConvertScreenState();
  }
}

class _ConvertScreenState extends State<ConvertScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<ConvertBloc>().startGettingData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<ConvertBloc>().state;
    final isLoading = state is ConvertLoadingState;

    return MultiBlocListener(
      listeners: _getListeners(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Convert'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Visibility(
            visible: !isLoading,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CurrencyInput(
                  hint: 'FROM',
                  controller: _fromController,
                  options: state.options ?? [],
                  onValueChanged: (String value) {
                    context.read<ConvertBloc>().convertTo(value);
                  },
                  onOptionChanged: (String? value) {
                    context.read<ConvertBloc>().selectCurrency(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: theme.primaryColor,
                        size: 16,
                      ),
                      Icon(
                        Icons.arrow_upward_rounded,
                        color: theme.primaryColor,
                        size: 16,
                      )
                    ],
                  ),
                ),
                CurrencyInput(
                  hint: 'TO',
                  controller: _toController,
                  options: const [MapEntry('BTC', '₿')],
                  onValueChanged: (String value) {},
                  enabled: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BlocListener> _getListeners(context) {
    return [
      BlocListener<ConvertBloc, ConvertState>(
        listener: (context, state) {
          _toController.text = state.to ?? '';
        },
        listenWhen: (prev, next) {
          return prev.to != next.to;
        },
      ),
    ];
  }
}
