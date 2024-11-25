import 'package:flutter_bloc/flutter_bloc.dart';

class FilterWidgetCubit extends Cubit<Map<String, dynamic>> {
  FilterWidgetCubit()
      : super({
    "selectedCategories": <String>[], // Seçilen kategoriler
    "selectedBrands": <String>[], // Seçilen markalar
    "availableCategories": <String>[], // Mevcut kategoriler
    "availableBrands": <String>[], // Mevcut markalar
    "selectedSorting": "Recommended", // Varsayılan sıralama türü
  });

  /// Filtrelerin başlatılması
  /// Mevcut kategoriler ve markalar başlangıç olarak ayarla
  void initializeFilters({required List<String> categories, required List<String> brands}) {
    emit({
      ...state,
      "availableCategories": categories, // Başlatılan kategoriler
      "availableBrands": brands, // Başlatılan markalar
    });
  }

  /// Mevcut kategoriler ve markaları günceller
  /// Filtreleme seçeneklerinin dinamik olarak değişmesi için kullanılır
  void updateAvailableOptions({required List<String> categories, required List<String> brands}) {
    emit({
      ...state, // Mevcut durum korunur
      "availableCategories": categories, // Güncellenen kategoriler
      "availableBrands": brands, // Güncellenen markalar
    });
  }

  /// Belirli bir filtreye yeni bir seçenek ekler
  /// Örneğin, kullanıcı bir kategori seçtiğinde bu metot kullanılır
  void addOption(String filterType, String option) {
    final selectedOptions = List<String>.from(state[filterType] ?? []); // Mevcut seçenekleri al
    if (!selectedOptions.contains(option)) { // Seçenek zaten mevcut değilse
      selectedOptions.add(option); // Yeni seçenek eklenir
      emit({...state, filterType: selectedOptions}); // Durum güncellenir
    }
  }

  /// Belirli bir filtreden bir seçeneği kaldırır
  /// Örneğin, kullanıcı bir kategoriyi kaldırdığında bu metot kullanılır
  void removeOption(String filterType, String option) {
    final selectedOptions = List<String>.from(state[filterType] ?? []); // Mevcut seçenekler alınıyor
    if (selectedOptions.contains(option)) { // Seçenek mevcutsa
      selectedOptions.remove(option); // Seçenek kaldırılır
      emit({...state, filterType: selectedOptions}); // Durum güncellenir
    }
  }

  /// Belirli bir filtre türündeki tüm seçenekleri temizler
  /// Örneğin, tüm kategoriler veya markalar sıfırlanmak istendiğinde kullanılır
  void clearOptions(String filterType) {
    emit({...state, filterType: []}); // İlgili filtre sıfırlanır
  }

  /// Belirli bir filtre türünden seçilen seçenekleri döndürür
  /// Örneğin, seçilen kategoriler veya markalar elde edilir
  List<String> getSelectedOptions(String filterType) {
    return List<String>.from(state[filterType] ?? []); // Mevcut seçenekler döndürülür
  }

  /// Sıralama türünü ayarlar
  /// Örneğin, kullanıcı "Fiyata göre sıralama" seçtiğinde kullanılır
  void setSorting(String sorting) {
    emit({...state, "selectedSorting": sorting}); // Sıralama güncellenir
  }

  /// Seçilen sıralama türünü döndürür
  /// Eğer bir sıralama türü seçilmemişse varsayılan olarak "Recommended" döner
  String getSelectedSorting() {
    return state["selectedSorting"] ?? "Recommended"; // Seçilen sıralama döndürülür
  }
}
