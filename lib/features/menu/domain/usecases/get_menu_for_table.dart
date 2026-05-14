import '../entities/menu_catalog.dart';
import '../repositories/menu_repository.dart';

class GetMenuForTable {
  const GetMenuForTable(this._repository);

  final MenuRepository _repository;

  Future<MenuCatalog> call(String tableId) {
    return _repository.getMenu(tableId: tableId);
  }
}
