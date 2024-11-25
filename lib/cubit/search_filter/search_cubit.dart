import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<String?> {
  SearchCubit() : super(null);

  /// Arama sorgusunu ayarla
  void setSearchQuery(String query) {
    emit(query);
  }

  /// Arama sorgusunu temizle
  void clearSearchQuery() {
    emit(null);
  }
}

