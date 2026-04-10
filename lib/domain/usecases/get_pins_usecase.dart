import 'package:pinterest_clone/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/domain/repositories/pin_repository.dart';

class GetPinsUseCase {
  final PinRepository repository;

  GetPinsUseCase(this.repository);

  Future<List<PinEntity>> call({int page = 1, int perPage = 15}) {
    return repository.getCuratedPins(page, perPage);
  }
}

class SearchPinsUseCase {
  final PinRepository repository;

  SearchPinsUseCase(this.repository);

  Future<List<PinEntity>> call(String query, {int page = 1, int perPage = 15}) {
    return repository.searchPins(query, page, perPage);
  }
}
