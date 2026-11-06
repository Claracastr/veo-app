import 'package:flutter/material.dart';
import 'package:veo_design_system/veo_design_system.dart';
import '../../models/vehicle_listing.dart';
import '../../services/vehicle_repository.dart';
import 'owner_view_model.dart';

class OwnerView extends StatefulWidget {
 final VehicleRepository repository;
 const OwnerView({super.key,required this.repository});
 @override State<OwnerView> createState()=>_OwnerViewState();
}
class _OwnerViewState extends State<OwnerView> {
 late final OwnerViewModel vm=OwnerViewModel(widget.repository);
 @override void initState(){super.initState();vm.addListener(_onChange);vm.load();}
 void _onChange(){if(mounted)setState((){});}
 @override void dispose(){vm.removeListener(_onChange);vm.dispose();super.dispose();}
 Future<void> _newListing() async {
  final created=await Navigator.of(context).push<bool>(MaterialPageRoute(builder:(_)=>NewListingView(repository:widget.repository)));
  if(created==true)vm.load();
 }
 @override Widget build(BuildContext context)=>RefreshIndicator(onRefresh:vm.load,child:ListView(padding:const EdgeInsets.all(22),children:[
  const SizedBox(height:8),Text('Anuncie seu carro',style:Theme.of(context).textTheme.headlineMedium),
  const SizedBox(height:10),const Text('Transforme seu carro em uma oportunidade. Cadastre um anúncio de demonstração e gerencie sua disponibilidade.',style:TextStyle(color:VeoColors.muted)),
  const SizedBox(height:22),Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:VeoColors.forest,borderRadius:BorderRadius.circular(24)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    const Icon(Icons.directions_car_filled_outlined,color:VeoColors.mint,size:38),const SizedBox(height:12),
    const Text('Seu carro. Sua renda extra.',style:TextStyle(color:Colors.white,fontSize:24,fontWeight:FontWeight.w800)),
    const SizedBox(height:8),const Text('Crie seu anúncio e receba solicitações futuramente.',style:TextStyle(color:Colors.white70)),
    const SizedBox(height:18),VeoButton(label:'Cadastrar meu carro',secondary:true,icon:Icons.add,onPressed:_newListing),
  ])),const SizedBox(height:24),const VeoSectionTitle(title:'Meus anúncios'),const SizedBox(height:12),
  if(vm.loading)const Center(child:CircularProgressIndicator())
  else if(vm.error!=null)Text(vm.error!,style:const TextStyle(color:VeoColors.danger))
  else if(vm.items.isEmpty)const Padding(padding:EdgeInsets.symmetric(vertical:28),child:VeoState(icon:Icons.car_rental,title:'Nenhum carro anunciado',message:'Toque em Cadastrar meu carro para começar.'))
  else ...vm.items.map((v)=>Card(margin:const EdgeInsets.only(bottom:14),child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Row(children:[if(v.imageUrl.isNotEmpty)ClipRRect(borderRadius:BorderRadius.circular(12),child:Image.network(v.imageUrl,width:90,height:75,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const SizedBox(width:90,child:Icon(Icons.car_rental)))) else const Icon(Icons.car_rental,size:50),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(v.name,style:Theme.of(context).textTheme.titleMedium),Text(v.city),Text('R\$ ${v.dailyPrice.toStringAsFixed(0)}/dia')]))]),
    const SizedBox(height:12),Text(v.status=='active'?'● Anúncio ativo':'● Anúncio pausado',style:TextStyle(color:v.status=='active'?VeoColors.forest:VeoColors.muted,fontWeight:FontWeight.w600)),
    Align(alignment:Alignment.centerRight,child:TextButton.icon(onPressed:()async {await vm.changeStatus(v.id,v.status=='active'?'paused':'active');},icon:Icon(v.status=='active'?Icons.pause_circle_outline:Icons.play_circle_outline),label:Text(v.status=='active'?'Pausar anúncio':'Reativar anúncio')))
  ])))),
  const SizedBox(height:26),const Text('Protótipo acadêmico: o cadastro não valida documentos, propriedade do veículo, seguro ou pagamentos.',style:TextStyle(color:VeoColors.muted,fontSize:12)),
 ]));
}
class NewListingView extends StatefulWidget {
 final VehicleRepository repository;
 const NewListingView({super.key,required this.repository});
 @override State<NewListingView> createState()=>_NewListingViewState();
}
class _NewListingViewState extends State<NewListingView> {
 final keyForm=GlobalKey<FormState>();
 final brand=TextEditingController(),model=TextEditingController(),year=TextEditingController(),city=TextEditingController(),price=TextEditingController(),description=TextEditingController(),photo1=TextEditingController(),photo2=TextEditingController(),photo3=TextEditingController();
 String transmission='Automático',fuel='Flex';int seats=5;bool loading=false;
 @override void dispose(){for(final c in [brand,model,year,city,price,description,photo1,photo2,photo3]){c.dispose();}super.dispose();}
 Widget field(String label,TextEditingController controller,{TextInputType? type,bool requiredField=true,int lines=1})=>Padding(padding:const EdgeInsets.only(bottom:14),child:TextFormField(controller:controller,keyboardType:type,maxLines:lines,decoration:InputDecoration(labelText:label),validator:(v){if(requiredField&&(v==null||v.trim().isEmpty))return 'Preencha este campo';return null;}));
 Future<void> save() async {
  if(!keyForm.currentState!.validate())return;
  final yearNum=int.tryParse(year.text.trim());final money=double.tryParse(price.text.trim().replaceAll(',','.'));
  if(yearNum==null||yearNum<1980||yearNum>DateTime.now().year+1||money==null||money<=0||money>10000){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Confira o ano e a diária (maior que zero e até R\$ 10.000).')));return;}
  final photos=[photo1.text.trim(),photo2.text.trim(),photo3.text.trim()].where((v)=>v.isNotEmpty).toList();
  if(photos.any((s)=>!['https'].contains(Uri.tryParse(s)?.scheme))){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('As fotos devem ter links HTTPS válidos.')));return;}
  setState(()=>loading=true);
  try {
   await widget.repository.createListing({'brand':brand.text.trim(),'model':model.text.trim(),'year':yearNum.toString(),'city':city.text.trim(),'dailyPrice':money,'description':description.text.trim(),'transmission':transmission,'fuel':fuel,'seats':seats,'imageUrl':photos.isEmpty?'':photos.first,'photoUrls':photos});
   if(mounted)Navigator.pop(context,true);
  }catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Erro ao salvar anúncio: $e')));}finally{if(mounted)setState(()=>loading=false);}
 }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Novo anúncio')),body:Form(key:keyForm,child:ListView(padding:const EdgeInsets.all(22),children:[
  Text('Conte sobre seu carro',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:8),const Text('Preencha os dados que aparecerão no catálogo.',style:TextStyle(color:VeoColors.muted)),const SizedBox(height:22),
  field('Marca (ex.: Toyota)',brand),field('Modelo (ex.: Corolla)',model),field('Ano',year,type:TextInputType.number),field('Cidade e UF (ex.: Palmas, TO)',city),field('Diária em R\$',price,type:const TextInputType.numberWithOptions(decimal:true)),
  DropdownButtonFormField<String>(value:transmission,decoration:const InputDecoration(labelText:'Câmbio'),items:['Automático','Manual'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v)=>setState(()=>transmission=v!)),const SizedBox(height:14),
  DropdownButtonFormField<String>(value:fuel,decoration:const InputDecoration(labelText:'Combustível'),items:['Flex','Gasolina','Diesel','Elétrico','Híbrido'].map((v)=>DropdownMenuItem(value:v,child:Text(v))).toList(),onChanged:(v)=>setState(()=>fuel=v!)),const SizedBox(height:14),
  DropdownButtonFormField<int>(value:seats,decoration:const InputDecoration(labelText:'Lugares'),items:[2,4,5,7,8].map((v)=>DropdownMenuItem(value:v,child:Text('$v lugares'))).toList(),onChanged:(v)=>setState(()=>seats=v!)),const SizedBox(height:14),
  field('Descrição',description,lines:3),const SizedBox(height:10),Text('Fotos do veículo',style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:8),const Text('Cole links HTTPS de fotos do seu carro. Você pode adicionar até três fotos nesta versão.',style:TextStyle(color:VeoColors.muted)),const SizedBox(height:12),
  field('URL da foto principal (opcional)',photo1,requiredField:false),field('URL da foto 2 (opcional)',photo2,requiredField:false),field('URL da foto 3 (opcional)',photo3,requiredField:false),const SizedBox(height:14),VeoButton(label:'Publicar anúncio',icon:Icons.check,loading:loading,onPressed:save),const SizedBox(height:20),
 ])));
}
