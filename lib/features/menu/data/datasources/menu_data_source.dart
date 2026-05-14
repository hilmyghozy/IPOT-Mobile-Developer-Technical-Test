import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/json_asset_loader.dart';
import '../models/menu_catalog_model.dart';

abstract class MenuDataSource {
  Future<MenuCatalogModel> getMenu({required String tableId});
}

class LocalMenuDataSource implements MenuDataSource {
  const LocalMenuDataSource({required JsonAssetLoader assetLoader})
    : _assetLoader = assetLoader;

  final JsonAssetLoader _assetLoader;

  @override
  Future<MenuCatalogModel> getMenu({required String tableId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 850));

    final json = await _assetLoader.loadObject('assets/mock/menu.json');
    final catalog = MenuCatalogModel.fromJson(json);

    if (catalog.restaurant.tableId != tableId) {
      throw NotFoundException(
        'No local menu is configured for table $tableId. Try scanning ipot://table/T001.',
      );
    }

    return catalog;
  }
}
