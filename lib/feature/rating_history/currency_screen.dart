import 'package:btc_rate/feature/rating_history/currency_bloc.dart';
import 'package:btc_rate/feature/rating_history/currency_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CurrencyScreenState();
  }
}

class CurrencyScreenState extends State<CurrencyScreen> {
  ChartSeriesController? _chartController;

  @override
  void initState() {
    super.initState();

    context.read<CurrencyBloc>().startGettingData();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CurrencyBloc>().state;
    final currency = state.currency;
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: _getListeners(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('BTC / ${currency?.code ?? '-'}'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                currency?.rate ?? '0',
                style: theme.textTheme.titleLarge,
              ),
              Text(
                '~ ${currency?.symbol ?? ''}${currency?.rate ?? '0'}',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  visibleMinimum: DateTime.now().subtract(
                    const Duration(
                      minutes: 10,
                    ),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  anchorRangeToVisiblePoints: false,
                  labelStyle: theme.textTheme.labelSmall,
                  opposedPosition: true,
                  majorGridLines: MajorGridLines(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                  minorGridLines: MinorGridLines(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
                  enablePanning: true,
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  lineType: TrackballLineType.none,
                ),
                crosshairBehavior: CrosshairBehavior(enable: true),
                series: <FastLineSeries<MapEntry<String, num>, DateTime>>[
                  FastLineSeries<MapEntry<String, num>, DateTime>(
                    onRendererCreated: (controller) {
                      _chartController = controller;
                    },
                    dataSource: state.series.entries.toList(),
                    xValueMapper: (MapEntry<String, num> data, _) =>
                        DateTime.parse(data.key),
                    yValueMapper: (MapEntry<String, num> data, _) => data.value,
                    animationDuration: 0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateChart(Map<String, num> series) {
    final newSeries = Map.from(series).entries.toList();
    _chartController?.updateDataSource(
      addedDataIndexes: <int>[newSeries.length - 1],
    );
  }

  List<BlocListener> _getListeners(context) {
    return [
      BlocListener<CurrencyBloc, CurrencyState>(listener: (context, state) {
        _updateChart(state.series);
      }, listenWhen: (prev, next) {
        return prev.series != next.series;
      })
    ];
  }
}
