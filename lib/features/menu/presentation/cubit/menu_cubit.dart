import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/menu_catalog.dart';
import '../../domain/usecases/get_menu_for_table.dart';

enum MenuStatus { initial, loading, success, failure }

class MenuState extends Equatable {
  const MenuState({
    this.status = MenuStatus.initial,
    this.catalog,
    this.errorMessage,
    this.query = '',
    this.selectedCategoryId,
  });

  static const Object _unset = Object();

  final MenuStatus status;
  final MenuCatalog? catalog;
  final String? errorMessage;
  final String query;
  final int? selectedCategoryId;

  List<MenuCategory> get categories => catalog?.categories ?? const [];

  List<MenuItem> get visibleItems {
    final currentCatalog = catalog;
    if (currentCatalog == null) {
      return const [];
    }

    return currentCatalog.filterItems(
      categoryId: selectedCategoryId,
      query: query,
    );
  }

  MenuState copyWith({
    MenuStatus? status,
    MenuCatalog? catalog,
    String? errorMessage,
    String? query,
    Object? selectedCategoryId = _unset,
  }) {
    return MenuState(
      status: status ?? this.status,
      catalog: catalog ?? this.catalog,
      errorMessage: errorMessage,
      query: query ?? this.query,
      selectedCategoryId: selectedCategoryId == _unset
          ? this.selectedCategoryId
          : selectedCategoryId as int?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    catalog,
    errorMessage,
    query,
    selectedCategoryId,
  ];
}

class MenuCubit extends Cubit<MenuState> {
  MenuCubit({required GetMenuForTable getMenuForTable})
    : _getMenuForTable = getMenuForTable,
      super(const MenuState());

  final GetMenuForTable _getMenuForTable;

  Future<void> loadMenu(String tableId) async {
    emit(
      state.copyWith(
        status: MenuStatus.loading,
        errorMessage: null,
        selectedCategoryId: null,
      ),
    );

    try {
      final catalog = await _getMenuForTable(tableId);
      emit(
        state.copyWith(
          status: MenuStatus.success,
          catalog: catalog,
          errorMessage: null,
          selectedCategoryId: null,
        ),
      );
    } on AppException catch (error) {
      emit(
        state.copyWith(status: MenuStatus.failure, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MenuStatus.failure,
          errorMessage: 'We could not load the menu right now.',
        ),
      );
    }
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(query: query));
  }

  void selectCategory(int? categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }
}
