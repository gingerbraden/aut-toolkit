import 'package:dio/dio.dart';

import 'arasaac_api.dart';

/// ARASAAC API service, used to get communication symbols
class ARASAACService {
  final ARASAACAPI _api = ARASAACAPI();

  static const String PICTOGRAM_SEARCH_PATH = "/pictograms/en/search/";
  static const String PICTOGRAM_IMAGE_PATH = "https://static.arasaac.org/pictograms/";
  static const int PICTOGRAM_SIZE_300 = 300;

  /// The main method that returns the list of symbols.
  ///
  /// [searchText] is the query used to search for the symbols.
  Future<List<dynamic>> searchPictograms({
    required String searchText,
  }) async {
    try {
      final response = await _api.dio.get(
          PICTOGRAM_SEARCH_PATH + searchText,
      );

      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      } else {
        throw Exception(
          'Failed: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.response?.data ?? e.message}');
    }
  }

  String getPictogramUrl(
      int id, {
        int size = PICTOGRAM_SIZE_300,
        String? action,
        String? hair,
        String? skin,
        bool plural = false,
        bool noColor = false,
      }) {
    final parts = <String>[];

    if (plural) parts.add('plural');
    if (noColor) parts.add('nocolor');
    if (action != null) parts.add('action-$action');
    if (hair != null) parts.add('hair-$hair');
    if (skin != null) parts.add('skin-$skin');

    final filename = parts.isEmpty ? '$id' : '${id}_${parts.join('_')}';
    return '$PICTOGRAM_IMAGE_PATH$id/${filename}_$size.png';
  }
}