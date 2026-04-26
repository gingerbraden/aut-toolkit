import 'package:aut_toolkit/core/model/mapper/pictogram_mappers.dart';
import '../model/Pictogram.dart';
import '../model/dto/pictogram_dto.dart';
import '../services/arasaac_service.dart';

/// Repository layer used for accessing the ARASAAC API
class ARASAACRepository {
  final ARASAACService _service = ARASAACService();

  Future<List<Pictogram>> searchPictograms(String searchText) async {
    try {
      final List<dynamic> responseData =
      await _service.searchPictograms(searchText: searchText);

      final List<PictogramDTO> dtoList = responseData
          .map((json) => PictogramDTO.fromJson(json))
          .toList();

      final List<Pictogram> domainList = dtoList.map((dto) => dto.toDomain()).toList();

      return domainList;
    } catch (e) {
      rethrow;
    }
  }

  String getPictogramUrl(
      int id, {
        int size = ARASAACService.PICTOGRAM_SIZE_300,
        String? action,
        String? hair,
        String? skin,
        bool plural = false,
        bool noColor = false,
      }) {
    return _service.getPictogramUrl(
      id,
      size: size,
      action: action,
      hair: hair,
      skin: skin,
      plural: plural,
      noColor: noColor,
    );
  }
}
