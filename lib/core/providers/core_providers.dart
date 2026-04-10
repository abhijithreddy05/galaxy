import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/network/dio_client.dart';
import 'package:pinterest_clone/data/repositories/pin_repository_impl.dart';
import 'package:pinterest_clone/domain/repositories/pin_repository.dart';
import 'package:pinterest_clone/domain/usecases/get_pins_usecase.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final pinRepositoryProvider = Provider<PinRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PinRepositoryImpl(dioClient);
});

final getPinsUseCaseProvider = Provider<GetPinsUseCase>((ref) {
  final repository = ref.watch(pinRepositoryProvider);
  return GetPinsUseCase(repository);
});

final searchPinsUseCaseProvider = Provider<SearchPinsUseCase>((ref) {
  final repository = ref.watch(pinRepositoryProvider);
  return SearchPinsUseCase(repository);
});
