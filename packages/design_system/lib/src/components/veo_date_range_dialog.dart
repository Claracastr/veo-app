import 'package:flutter/material.dart';
import '../theme/veo_theme.dart';
import 'veo_button.dart';

/// Seletor compacto do Design System VEO.
/// O usuário escolhe retirada e devolução e confirma em um botão padrão.
class VeoDateRangeDialog extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialRange;

  const VeoDateRangeDialog({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialRange,
  });

  @override
  State<VeoDateRangeDialog> createState() => _VeoDateRangeDialogState();
}

class _VeoDateRangeDialogState extends State<VeoDateRangeDialog> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange?.start;
    _end = widget.initialRange?.end;
  }

  String _format(DateTime? value) => value == null
      ? 'Selecionar data'
      : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  Future<void> _selectStart() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: _start ?? widget.firstDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      helpText: 'DATA DE RETIRADA',
      cancelText: 'Cancelar',
      confirmText: 'Escolher',
    );
    if (chosen == null || !mounted) return;
    setState(() {
      _start = chosen;
      if (_end != null && _end!.isBefore(chosen)) _end = null;
    });
  }

  Future<void> _selectEnd() async {
    if (_start == null) return;
    final chosen = await showDatePicker(
      context: context,
      initialDate: _end != null && !_end!.isBefore(_start!) ? _end! : _start!,
      firstDate: _start!,
      lastDate: widget.lastDate,
      helpText: 'DATA DE DEVOLUÇÃO',
      cancelText: 'Cancelar',
      confirmText: 'Escolher',
    );
    if (chosen == null || !mounted) return;
    setState(() => _end = chosen);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              const Expanded(child: Text('Período da reserva', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))),
              IconButton(tooltip: 'Fechar', onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 6),
            const Text('Escolha as datas para retirar e devolver seu carro.', style: TextStyle(color: VeoColors.muted)),
            const SizedBox(height: 24),
            _dateTile('Retirada', _format(_start), Icons.calendar_today_outlined, _selectStart),
            const SizedBox(height: 12),
            _dateTile('Devolução', _format(_end), Icons.event_available_outlined, _start == null ? null : _selectEnd),
            const SizedBox(height: 22),
            VeoButton(
              label: 'Confirmar período',
              icon: Icons.check,
              onPressed: _start == null || _end == null
                  ? null
                  : () => Navigator.pop(context, DateTimeRange(start: _start!, end: _end!)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _dateTile(String title, String date, IconData icon, VoidCallback? onTap) {
    return Material(
      color: VeoColors.mint.withOpacity(0.35),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Icon(icon, color: VeoColors.forest),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 12, color: VeoColors.muted)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ])),
            const Icon(Icons.chevron_right, color: VeoColors.forest),
          ]),
        ),
      ),
    );
  }
}
