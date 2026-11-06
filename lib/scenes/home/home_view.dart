import 'package:flutter/material.dart';
import 'package:veo_design_system/veo_design_system.dart';
import '../../services/vehicle_repository.dart';
import '../bookings/bookings_view.dart';
import '../owner/owner_view.dart';
import '../../models/vehicle.dart';
import 'home_factory.dart';
import 'home_view_model.dart';
import 'home_coordinator.dart';

class HomeView extends StatefulWidget {
  final VehicleRepository repository;
  const HomeView({super.key, required this.repository});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel vm = HomeFactory.create(widget.repository);
  final search = TextEditingController();
  int tab = 0;
  String transmission = 'Todos';
  String category = 'Todos';
  double maxPrice = 600;
  bool filtersOpen = false;
  bool _passes(Vehicle car) {
   final type=car.model.toLowerCase();
   final suv=['creta','tracker','nivus','pulse','cross','hr-v','renegade','compass','kicks','t-cross'];
   final sedan=['corolla','virtus','civic','onix plus','city','versa'];
   final kind=suv.any(type.contains)?'SUV':sedan.any(type.contains)?'Sedã':'Hatch/Outros';
   return car.dailyPrice <= maxPrice && (transmission=='Todos'||car.transmission==transmission) && (category=='Todos'||kind==category);
  }

  @override
  void initState() {
    super.initState();
    vm.addListener(_update);
    vm.load();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    vm.removeListener(_update);
    vm.dispose();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (index) { setState(() => tab = index); if(index == 0) vm.load(search.text); },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Explorar'),
            NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined), label: 'Reservas'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Anunciar'),
            NavigationDestination(
                icon: Icon(Icons.person_outline), label: 'Perfil')
          ]),
      body: SafeArea(
          child: tab == 1
              ? BookingsView(repository: widget.repository)
              : tab == 2
                  ? OwnerView(repository: widget.repository)
                  : tab == 3
                  ? _profile(context)
                  : RefreshIndicator(
                      onRefresh: () => vm.load(search.text),
                      child: CustomScrollView(slivers: [
                        SliverToBoxAdapter(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(22, 20, 22, 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        const Text('veo.',
                                            style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w900,
                                                color: VeoColors.forest)),
                                        const Spacer(),
                                        Container(
                                            padding: const EdgeInsets.all(11),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: const Icon(Icons
                                                .notifications_none_rounded))
                                      ]),
                                      const SizedBox(height: 30),
                                      Text('Encontre o carro ideal para você.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall),
                                      const SizedBox(height: 12),
                                      const Text(
                                          'Escolha seu destino. O caminho é seu.',
                                          style: TextStyle(
                                              color: VeoColors.muted)),
                                      const SizedBox(height: 24),
                                      VeoTextField(
                                          label: 'Buscar carro ou cidade',
                                          hint: 'Ex.: Palmas, Jeep...',
                                          prefixIcon: Icons.search,
                                          controller: search,
                                          onChanged: vm.load),
                                      const SizedBox(height: 12),
                                      Align(alignment: Alignment.centerRight, child: TextButton.icon(
                                        onPressed: ()=>setState(()=>filtersOpen=!filtersOpen),
                                        icon: const Icon(Icons.tune), label: Text(filtersOpen?'Ocultar filtros':'Filtrar carros'))),
                                      if (filtersOpen) Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
                                        const Text('Câmbio',style:TextStyle(fontWeight:FontWeight.bold)),
                                        Wrap(spacing:8,children:['Todos','Automático','Manual'].map((v)=>ChoiceChip(label:Text(v),selected:transmission==v,onSelected:(_)=>setState(()=>transmission=v))).toList()),
                                        const SizedBox(height:12),const Text('Categoria',style:TextStyle(fontWeight:FontWeight.bold)),
                                        Wrap(spacing:8,children:['Todos','SUV','Sedã','Hatch/Outros'].map((v)=>ChoiceChip(label:Text(v),selected:category==v,onSelected:(_)=>setState(()=>category=v))).toList()),
                                        const SizedBox(height:12),Text('Até R\$ ${maxPrice.toStringAsFixed(0)} por dia'),
                                        Slider(value:maxPrice,min:100,max:600,divisions:20,onChanged:(v)=>setState(()=>maxPrice=v)),
                                        TextButton(onPressed:()=>setState(() { transmission='Todos';category='Todos';maxPrice=600; }),child:const Text('Limpar filtros')),
                                      ]))),
                                      const SizedBox(height: 18),
                                      Container(
                                          padding: const EdgeInsets.all(21),
                                          decoration: BoxDecoration(
                                              color: VeoColors.forest,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          child: const Row(children: [
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Text(
                                                      'SUA PRÓXIMA VIAGEM',
                                                      style: TextStyle(
                                                          color: VeoColors.mint,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 1.5)),
                                                  SizedBox(height: 9),
                                                  Text(
                                                      'Mais liberdade. Menos complicação.',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                                  SizedBox(height: 8),
                                                  Text(
                                                      'Alugue por dia, do seu jeito.',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white70))
                                                ])),
                                            Icon(Icons.route_rounded,
                                                size: 55, color: VeoColors.mint)
                                          ])),
                                      const SizedBox(height: 24),
                                      const VeoSectionTitle(
                                          title: 'Carros disponíveis'),
                                      const SizedBox(height: 10),
                                    ]))),
                        if (vm.loading)
                          const SliverFillRemaining(
                              child: Center(child: CircularProgressIndicator()))
                        else if (vm.error != null)
                          SliverFillRemaining(
                              child: VeoState(
                                  icon: Icons.wifi_off,
                                  title: 'Ops!',
                                  message: 'Falha ao buscar veículos.',
                                  action: 'Tentar novamente',
                                  onAction: () => vm.load(search.text)))
                        else if (vm.cars.where(_passes).isEmpty)
                          const SliverFillRemaining(
                              child: VeoState(
                                  icon: Icons.search_off,
                                  title: 'Nenhum resultado',
                                  message: 'Tente outro nome ou cidade.'))
                        else
                          SliverPadding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
                              sliver: SliverList.builder(
                                  itemCount: vm.cars.where(_passes).length,
                                  itemBuilder: (context, index) {
                                    final car = vm.cars.where(_passes).toList()[index];
                                    return VeoVehicleCard(
                                        name: car.name,
                                        location: car.city,
                                        imageUrl: car.imageUrl,
                                        price: car.dailyPrice,
                                        rating: car.rating,
                                        transmission: car.transmission,
                                        onTap: () =>
                                            HomeCoordinator(widget.repository)
                                                .openVehicle(context, car));
                                  }))
                      ]))));
  Widget _profile(BuildContext context) => Padding(
      padding: const EdgeInsets.all(25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 20),
        Text('Meu perfil', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 28),
        const CircleAvatar(
            radius: 36,
            backgroundColor: VeoColors.mint,
            child: Icon(Icons.person, size: 38, color: VeoColors.forest)),
        const SizedBox(height: 18),
        const Text('Clara Castro',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const Text('clara@veo.app', style: TextStyle(color: VeoColors.muted)),
        const SizedBox(height: 25),
        const ListTile(
            leading: Icon(Icons.verified_user_outlined),
            title: Text('Conta de demonstração'),
            subtitle: Text('Dados simulados para projeto acadêmico'))
      ]));
}
