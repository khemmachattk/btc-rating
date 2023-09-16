import 'package:btc_rate/core/model/rating.dart';
import 'package:btc_rate/feature/home/home_bloc.dart';
import 'package:btc_rate/feature/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().startGettingData();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<HomeBloc>().state;
    final isLoading = state is HomeLoadingState;
    final bpi = state.rating?.bpi;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bitcoin'),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Lasted update: ${state.rating?.time.updated ?? '-'}',
              style: textTheme.bodySmall,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Visibility(
          visible: !isLoading,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.separated(
            itemCount: bpi?.length ?? 0,
            itemBuilder: (context, index) {
              final currency = bpi!.values.toList()[index];
              final rateWithSymbol = '${currency.symbol}${currency.rate}';
              return InkWell(
                onTap: () => _onItemTapped(context, currency),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('BTC', style: textTheme.titleLarge),
                          Text(' / ${currency.code}',
                              style: textTheme.titleMedium),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(currency.rate, style: textTheme.bodyLarge),
                          Text(rateWithSymbol, style: textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 1, indent: 16);
            },
          ),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, Currency currency) {
    context.go('/home/currency/${currency.code}');
  }
}
