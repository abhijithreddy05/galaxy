import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/providers/core_providers.dart';
import 'package:pinterest_clone/domain/entities/pin_entity.dart';

final searchProvider = AsyncNotifierProvider<SearchNotifier, List<PinEntity>>(() {
  return SearchNotifier();
});

class SearchNotifier extends AsyncNotifier<List<PinEntity>> {
  int _currentPage = 1;
  String _currentQuery = '';

  @override
  FutureOr<List<PinEntity>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    
    _currentQuery = query;
    _currentPage = 1;
    state = const AsyncValue.loading();
    
    try {
      final searchPinsUseCase = ref.read(searchPinsUseCaseProvider);
      final pins = await searchPinsUseCase(query, page: _currentPage, perPage: 20);
      state = AsyncValue.data(pins);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || _currentQuery.isEmpty) return;
    
    final currentPins = state.value ?? [];
    state = const AsyncValue.loading();
    _currentPage++;
    
    try {
      final searchPinsUseCase = ref.read(searchPinsUseCaseProvider);
      final newPins = await searchPinsUseCase(_currentQuery, page: _currentPage, perPage: 20);
      state = AsyncValue.data([...currentPins, ...newPins]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
