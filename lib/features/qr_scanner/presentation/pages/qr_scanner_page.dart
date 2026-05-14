import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/widgets/section_shell.dart';
import '../../../../routes/app_router.dart';
import '../cubit/qr_scanner_cubit.dart';
import '../widgets/scan_overlay.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrScannerCubit, QrScannerState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == QrScannerStatus.invalid && state.message != null) {
          context.showAppSnackBar(state.message!);
          context.read<QrScannerCubit>().clearMessage();
          return;
        }

        if (state.status == QrScannerStatus.success && state.tableId != null) {
          _controller.stop();
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.menu,
            arguments: MenuRouteArgs(tableId: state.tableId!),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final barcode = capture.barcodes.isNotEmpty
                    ? capture.barcodes.first
                    : null;
                context.read<QrScannerCubit>().onBarcodeDetected(
                  barcode?.rawValue,
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.82),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IPOT QR Ordering',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Point the camera at a valid table QR to open the restaurant menu.',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const ScanOverlay(),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SectionShell(
                    backgroundColor: Colors.white.withValues(alpha: 0.94),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Camera fallback',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Use the sample table when camera access is not available in the simulator.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                context.read<QrScannerCubit>().useSampleTable(),
                            icon: const Icon(Icons.qr_code_2_outlined),
                            label: const Text('Use sample QR for T001'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
