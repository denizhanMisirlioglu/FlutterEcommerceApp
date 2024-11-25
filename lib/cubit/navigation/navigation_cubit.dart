import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // Varsayılan sekme: Home

  void navigateTo(int index) {
    emit(index);
  }
}
