import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/providers/core_providers.dart';
import 'package:pinterest_clone/domain/entities/pin_entity.dart';

final homePinsProvider = AsyncNotifierProvider<HomePinsNotifier, List<PinEntity>>(() {
  return HomePinsNotifier();
});

class HomePinsNotifier extends AsyncNotifier<List<PinEntity>> {
  int _currentPage = 1;

  @override
  FutureOr<List<PinEntity>> build() async {
    _currentPage = 1;
    final getPins = ref.read(getPinsUseCaseProvider);
    return getPins(page: _currentPage, perPage: 20);
  }

  Future<void> fetchMorePins() async {
    if (state.isLoading) return;
    
    final currentPins = state.value ?? [];
    
    state = const AsyncValue.loading();
    _currentPage++;
    try {
      final getPins = ref.read(getPinsUseCaseProvider);
      final newPins = await getPins(page: _currentPage, perPage: 20);
      state = AsyncValue.data([...currentPins, ...newPins]);
    } catch (e, st) {
      // It's usually better to not overwrite existing items on error when paginating, but for simplicity:
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    state = const AsyncValue.loading();
    try {
      final getPins = ref.read(getPinsUseCaseProvider);
      final pins = await getPins(page: _currentPage, perPage: 20);
      state = AsyncValue.data(pins);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
