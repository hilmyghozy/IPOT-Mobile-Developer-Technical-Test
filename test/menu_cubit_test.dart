import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipot_qr_ordering/features/menu/domain/usecases/get_menu_for_table.dart';
import 'package:ipot_qr_ordering/features/menu/presentation/cubit/menu_cubit.dart';

import 'test_helpers/test_data.dart';

void main() {
  group('MenuCubit', () {
    blocTest<MenuCubit, MenuState>(
      'loads menu data and filters items by category and search query',
      build: () =>
          MenuCubit(getMenuForTable: GetMenuForTable(FakeMenuRepository())),
      act: (cubit) async {
        await cubit.loadMenu('T001');
        cubit.selectCategory(2);
        cubit.updateSearchQuery('ramen');
      },
      verify: (cubit) {
        expect(cubit.state.status, MenuStatus.success);
        expect(cubit.state.categories, hasLength(3));
        expect(cubit.state.visibleItems, hasLength(1));
        expect(cubit.state.visibleItems.single.name, 'Chicken Ramen');
      },
    );
  });
}
