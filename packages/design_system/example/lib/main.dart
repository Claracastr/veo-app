import 'package:flutter/material.dart';
import 'package:veo_design_system/veo_design_system.dart';

void main() => runApp(const SampleApp());

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: VeoTheme.light,
        home: const Catalog(),
      );
}

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  int page = 0;
  final pages = ['Tokens', 'Botões', 'Inputs', 'Cards', 'Estados'];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('VEO • Sample App')),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text(
                      'veo.\nDESIGN SYSTEM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: VeoColors.forest,
                      ),
                    ),
                  ),
                ),
                ...List.generate(
                  pages.length,
                  (index) => ListTile(
                    title: Text(pages[index]),
                    selected: page == index,
                    onTap: () {
                      setState(() => page = index);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              pages[page],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 22),
            if (page == 0) ...[
              const Text('Paleta e espaçamento'),
              const SizedBox(height: 12),
              for (final color in [
                VeoColors.ink,
                VeoColors.forest,
                VeoColors.mint,
                VeoColors.canvas,
                VeoColors.muted,
                VeoColors.line,
              ])
                Container(
                  height: 46,
                  margin: const EdgeInsets.only(bottom: 9),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              const SizedBox(height: 10),
              const Text('Spacing: 4 / 8 / 16 / 24 / 32'),
              const Text('Radius: 12 / 18 / 26'),
              const SizedBox(height: 12),
              Text(
                'Título grande',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                'Título de seção',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text('Texto de corpo e legenda'),
            ] else if (page == 1) ...[
              VeoButton(label: 'Botão primário', onPressed: () {}),
              const SizedBox(height: 14),
              VeoButton(
                label: 'Botão secundário',
                secondary: true,
                onPressed: () {},
              ),
              const SizedBox(height: 14),
              const VeoButton(label: 'Carregando', loading: true),
              const SizedBox(height: 14),
              VeoButton(
                label: 'Com ícone',
                icon: Icons.arrow_forward,
                onPressed: () {},
              ),
            ] else if (page == 2) ...[
              const VeoTextField(
                label: 'Nome completo',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              const VeoTextField(
                label: 'E-mail',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 14),
              const VeoTextField(label: 'Senha', obscureText: true),
              const SizedBox(height: 20),
              const Wrap(
                spacing: 7,
                children: [
                  VeoChip(text: 'SUV', icon: Icons.directions_car),
                  VeoChip(text: 'Automático', selected: true),
                  VeoChip(text: 'Elétrico'),
                ],
              ),
            ] else if (page == 3) ...[
              const VeoSectionTitle(
                title: 'Veículos em destaque',
                action: 'Ver todos',
              ),
              const VeoVehicleCard(
                name: 'Jeep Renegade',
                location: 'Palmas, TO',
                imageUrl:
                    'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=900',
                price: 219,
                rating: 4.9,
                transmission: 'Automático',
              ),
            ] else ...[
              const Wrap(spacing: 8, runSpacing: 8, children: [
                VeoStatusBadge(status: 'pending'),
                VeoStatusBadge(status: 'confirmed'),
                VeoStatusBadge(status: 'cancelled'),
              ]),
              const SizedBox(height: 18),
              const VeoPriceTag(price: 219),
              const SizedBox(height: 40),
              const VeoState(
                icon: Icons.search_off,
                title: 'Nada encontrado',
                message: 'Tente outra busca para encontrar seu carro.',
              ),
              const SizedBox(height: 60),
              const VeoState(
                icon: Icons.wifi_off,
                title: 'Sem conexão',
                message: 'Verifique sua internet e tente novamente.',
              ),
            ],
          ],
        ),
      );
}
