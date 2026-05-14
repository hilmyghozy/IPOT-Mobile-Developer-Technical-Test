import '../entities/menu_catalog.dart';

abstract class MenuRepository {
  Future<MenuCatalog> getMenu({required String tableId});
}
