import 'package:flutter/material.dart';
import 'package:veo_design_system/veo_design_system.dart';
import '../../services/vehicle_repository.dart';
import 'bookings_factory.dart';
import 'bookings_view_model.dart';

class BookingsView extends StatefulWidget {
 final VehicleRepository repository;
 const BookingsView({super.key, required this.repository});
 @override State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
 late final BookingsViewModel vm = BookingsFactory.create(widget.repository);
 @override void initState() {
  super.initState();
  vm.addListener(_rebuild);
  vm.load();
 }
 void _rebuild() { if (mounted) setState(() {}); }
 @override void dispose() {
  vm.removeListener(_rebuild);
  vm.dispose();
  super.dispose();
 }
 @override Widget build(BuildContext context) => RefreshIndicator(
  onRefresh: vm.load,
  child: CustomScrollView(slivers: [
   SliverToBoxAdapter(child: Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
    child: Text('Minhas reservas', style: Theme.of(context).textTheme.headlineMedium),
   )),
   if (vm.loading)
    const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
   else if (vm.error != null)
    SliverFillRemaining(child: VeoState(
     icon: Icons.wifi_off, title: 'Não foi possível carregar',
     message: vm.error!, action: 'Tentar novamente', onAction: vm.load,
    ))
   else if (vm.items.isEmpty)
    const SliverFillRemaining(child: VeoState(
     icon: Icons.calendar_month_outlined, title: 'Sem reservas por aqui',
     message: 'Explore os carros e faça sua primeira solicitação.',
    ))
   else
    SliverPadding(
     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
     sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
      final booking = vm.items[index];
      return Card(
       margin: const EdgeInsets.only(bottom: 14),
       child: Padding(padding: const EdgeInsets.all(18), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
         Row(children: [
          Expanded(child: Text(vm.vehicleNames[booking.vehicleId] ?? 'Veículo ${booking.vehicleId}',
           style: Theme.of(context).textTheme.titleMedium)),
          VeoStatusBadge(status: booking.status),
         ]),
         const SizedBox(height: 12),
         Text('${booking.startDate} até ${booking.endDate}'),
         const SizedBox(height: 10),
         VeoPriceTag(price: booking.total, suffix: 'total'),
         if (booking.status != 'cancelled') ...[
          const SizedBox(height:10),
          Align(alignment:Alignment.centerRight,child:TextButton.icon(icon:const Icon(Icons.cancel_outlined),label:const Text('Cancelar reserva'),onPressed:() async {
            final confirm=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('Cancelar reserva?'),content:const Text('Essa ação libera as datas para outras solicitações.'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Voltar')),TextButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('Cancelar reserva'))]));
            if(confirm==true) await vm.cancel(booking.id);
          }))
         ],
        ],
       )),
      );
     }, childCount: vm.items.length)),
    ),
  ]),
 );
}
