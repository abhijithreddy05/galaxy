import 'package:pinterest_clone/domain/entities/pin_entity.dart';

abstract class PinRepository {
  Future<List<PinEntity>> getCuratedPins(int page, int perPage);
  Future<List<PinEntity>> searchPins(String query, int page, int perPage);
}
