import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/menu_catalog.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_data_source.dart';

class MenuRepositoryImpl implements MenuRepository {
  const MenuRepositoryImpl({required MenuDataSource dataSource})
    : _dataSource = dataSource;

  final MenuDataSource _dataSource;

  @override
  Future<MenuCatalog> getMenu({required String tableId}) async {
    try {
      final model = await _dataSource.getMenu(tableId: tableId);
      return model.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('We could not load the menu right now.');
    }
  }
}
