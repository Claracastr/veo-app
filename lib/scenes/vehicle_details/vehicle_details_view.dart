import 'package:flutter/material.dart';
import 'package:veo_design_system/veo_design_system.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_repository.dart';
import 'vehicle_details_factory.dart';
import 'vehicle_details_view_model.dart';

class VehicleDetailsView extends StatefulWidget {
  final Vehicle car;
  final VehicleRepository repository;
  const VehicleDetailsView(
      {super.key, required this.car, required this.repository});
  @override
  State<VehicleDetailsView> createState() => _VehicleDetailsViewState();
}

class _VehicleDetailsViewState extends State<VehicleDetailsView> {
  DateTimeRange? range;
  int photoIndex = 0;
  late final VehicleDetailsViewModel vm = VehicleDetailsFactory.create(widget.repository);
  @override void initState() { super.initState(); vm.addListener(_refresh); }
  void _refresh() { if (mounted) setState(() {}); }
  @override void dispose() { vm.removeListener(_refresh); vm.dispose(); super.dispose(); }
  Future<void> _book() async {
    final selected = await showDialog<DateTimeRange>(
      context: context,
      builder: (_) => VeoDateRangeDialog(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialRange: range,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() => range = selected);
    final days = selected.end.difference(selected.start).inDays+1;
    final price = widget.car.dailyPrice*days;
    final confirmed = await showModalBottomSheet<bool>(context:context,isScrollControlled:true,showDragHandle:true,builder:(ctx)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Resumo da reserva',style:Theme.of(ctx).textTheme.headlineMedium),const SizedBox(height:16),Text(widget.car.name,style:Theme.of(ctx).textTheme.titleLarge),
      const SizedBox(height:8),Text('Retirada: ${selected.start.day}/${selected.start.month}/${selected.start.year}'),
      Text('Devolução: ${selected.end.day}/${selected.end.month}/${selected.end.year}'),
      const SizedBox(height:12),Text('$days diária(s) × R\$ ${widget.car.dailyPrice.toStringAsFixed(2)}'),
      const Divider(height:28),Text('Total: R\$ ${price.toStringAsFixed(2)}',style:Theme.of(ctx).textTheme.titleLarge),
      const SizedBox(height:8),const Text('Você está enviando uma solicitação. Não há pagamento real nesta demonstração.'),
      const SizedBox(height:18),VeoButton(label:'Confirmar solicitação',onPressed:()=>Navigator.pop(ctx,true)),
      TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Voltar')),
    ]))));
    if (confirmed != true || !mounted) return;
    final ok = await vm.book(vehicleId: widget.car.id,
      start: selected.start, end: selected.end);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
        ? 'Reserva ${vm.createdBooking!.id} solicitada! Confira em Reservas.'
        : (vm.error ?? 'Não foi possível solicitar a reserva.')),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    return Scaffold(
        appBar: AppBar(title: const Text('Detalhes do carro')),
        bottomNavigationBar: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('R\$ ${car.dailyPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w900)),
                        const Text('por dia',
                            style: TextStyle(color: VeoColors.muted))
                      ])),
                  SizedBox(
                      width: 180,
                      child: VeoButton(
                          label: 'Reservar',
                          loading: vm.loading,
                          onPressed: _book))
                ]))),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 275,width:double.infinity,child:Stack(children:[
            PageView.builder(itemCount: car.photoUrls.isEmpty?1:car.photoUrls.length,onPageChanged:(i)=>setState(()=>photoIndex=i),itemBuilder:(ctx,i){final src=car.photoUrls.isEmpty?car.imageUrl:car.photoUrls[i];return src.isEmpty?const Center(child:Icon(Icons.directions_car,size:100)):Image.network(src,width:double.infinity,height:275,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const Center(child:Icon(Icons.directions_car,size:100)));}),
            Positioned(bottom:14,right:16,child:DecoratedBox(decoration:BoxDecoration(color:VeoColors.forest,borderRadius:BorderRadius.circular(30)),child:Padding(padding:const EdgeInsets.symmetric(horizontal:14,vertical:8),child:Text('${photoIndex+1}/${car.photoUrls.isEmpty?1:car.photoUrls.length} fotos',style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold))))),
          ])),
          Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(car.name,
                              style:
                                  Theme.of(context).textTheme.headlineMedium)),
                      if(car.rating > 0) ...[const Icon(Icons.star, color: Color(0xFFE4A923)),Text(car.rating.toStringAsFixed(1))] else const Text('Novo',style:TextStyle(color:VeoColors.forest))
                    ]),
                    const SizedBox(height: 8),
                    Text('${car.year}  •  ${car.city}',
                        style: const TextStyle(color: VeoColors.muted)),
                    const SizedBox(height: 26),
                    Wrap(spacing: 10, runSpacing: 7, children: [
                      VeoChip(text: car.transmission, icon: Icons.settings),
                      VeoChip(
                          text: '${car.seats} lugares',
                          icon: Icons.people_outline),
                      VeoChip(
                          text: car.fuel,
                          icon: Icons.local_gas_station_outlined)
                    ]),
                    const SizedBox(height: 28),
                    Text('Sobre este carro',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Text(car.description),
                    const SizedBox(height: 25),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Row(children: [
                      Icon(Icons.shield_outlined, color: VeoColors.forest),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(
                              'Solicitação sujeita à confirmação do proprietário.'))
                    ])
                  ]))
        ])));
  }
}
