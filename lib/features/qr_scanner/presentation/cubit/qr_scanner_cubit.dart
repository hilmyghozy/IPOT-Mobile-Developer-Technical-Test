import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/usecases/parse_table_qr.dart';

enum QrScannerStatus { initial, invalid, success }

class QrScannerState extends Equatable {
  const QrScannerState({
    this.status = QrScannerStatus.initial,
    this.tableId,
    this.message,
  });

  final QrScannerStatus status;
  final String? tableId;
  final String? message;

  @override
  List<Object?> get props => [status, tableId, message];
}

class QrScannerCubit extends Cubit<QrScannerState> {
  QrScannerCubit({required ParseTableQr parseTableQr})
    : _parseTableQr = parseTableQr,
      super(const QrScannerState());

  final ParseTableQr _parseTableQr;

  bool _hasSuccessfulScan = false;

  void onBarcodeDetected(String? rawValue) {
    if (_hasSuccessfulScan) {
      return;
    }

    try {
      if (rawValue == null || rawValue.trim().isEmpty) {
        throw const InvalidQrException(
          'We could not read that QR code. Please try again.',
        );
      }

      final tableId = _parseTableQr(rawValue);
      _hasSuccessfulScan = true;
      emit(QrScannerState(status: QrScannerStatus.success, tableId: tableId));
    } on AppException catch (error) {
      emit(
        QrScannerState(status: QrScannerStatus.invalid, message: error.message),
      );
    }
  }

  void clearMessage() {
    if (state.status == QrScannerStatus.invalid) {
      emit(const QrScannerState());
    }
  }

  void useSampleTable() {
    onBarcodeDetected('ipot://table/T001');
  }
}
