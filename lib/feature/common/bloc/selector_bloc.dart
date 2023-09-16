import 'package:flutter_bloc/flutter_bloc.dart';

class SelectorBloc<T> extends Cubit<T?> {
  SelectorBloc(): super(null);

  select(T? value) => emit(value);
}