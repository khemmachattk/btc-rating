import 'package:btc_rate/feature/app_shell_bloc.dart';
import 'package:btc_rate/feature/app_shell_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navShell;

  const AppShell({super.key, required this.navShell});

  @override
  State<StatefulWidget> createState() {
    return _AppShellState();
  }
}

class _AppShellState extends State<AppShell> {
  final scaffoldMessageKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    context.read<AppShellBloc>().startGettingData();
  }

  _dataListener(BuildContext context) {
    return [
      BlocListener<AppShellBloc, AppShellState>(
        listener: _handleAppShellState,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _dataListener(context),
      child: Scaffold(
        body: ScaffoldMessenger(
          key: scaffoldMessageKey,
          child: widget.navShell,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin),
              label: 'Bitcoin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Convert',
            ),
          ],
          currentIndex: widget.navShell.currentIndex,
          onTap: _onNavTapped,
        ),
      ),
    );
  }

  void _onNavTapped(int index) {
    widget.navShell.goBranch(
      index,
      initialLocation: index == widget.navShell.currentIndex,
    );
  }

  void _handleAppShellState(BuildContext context, AppShellState state) {
    if (state is AppShellErrorState) {
      _showErrorMessage(context, state.message);
    }
  }

  void _showErrorMessage(BuildContext context, String? message) {
    final controller = scaffoldMessageKey.currentState;
    final theme = Theme.of(context);
    controller?.showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        content: Text(
          message ?? '',
          style: TextStyle(color: theme.colorScheme.onError),
        ),
        backgroundColor: theme.colorScheme.error,
        actions: <Widget>[
          TextButton(
            onPressed: controller.hideCurrentMaterialBanner,
            child: Text(
              'DISMISS',
              style: TextStyle(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
