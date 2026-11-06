# VEO — definição, protótipos e critérios

## Tema / proposta
VEO é um marketplace acadêmico para **aluguel de carros entre pessoas** (modelo P2P). Em vez de comprar ou manter carro, o motorista busca opções por cidade, compara diárias e solicita uma reserva. O proprietário disponibilizaria seu veículo em uma fase posterior.

## Problema e público
Pessoas que precisam de carro por períodos curtos encontram processos pouco flexíveis; proprietários têm veículos ociosos. Público inicial: motoristas habilitados, viajantes e moradores de cidades atendidas.

## MVP desta entrega
1. Tela de login com credenciais simuladas.
2. Home com busca textual, campanha, lista de veículos e navegação inferior.
3. Tela de detalhes com foto, preço, características e solicitação de reserva com datas.
4. Aba de reservas com status pendente e preço total.
5. Perfil demonstrativo.
6. Design System em pacote Flutter reutilizável e Sample App independente.
7. Mock **local** em Dart e API mock HTTP em Node com contrato documentado.

## Protótipos / wireframes textuais
```
LOGIN                      HOME
┌───────────────────┐     ┌────────────────────────┐
│ veo.              │     │ veo.               ◯   │
│ Seu próximo       │     │ Encontre o carro       │
│ caminho começa... │     │ ideal para você.       │
│ [E-mail         ] │     │ [Buscar carro/cidade ] │
│ [Senha          ] │     │ ┏ Banner verde ━━━━━┓  │
│ [     Entrar    ] │     │ ┗━━━━━━━━━━━━━━━━━━━┛  │
└───────────────────┘     │ Carros disponíveis     │
                          │ ┌ imagem carro ──────┐ │
DETALHES                  │ │ Jeep Renegade ★4.9 │ │
┌───────────────────┐     │ │ Palmas  R$219/dia  │ │
│ ← Detalhes        │     │ └────────────────────┘ │
│ ┌ foto do carro ┐ │     │ Explorar Reservas Perfil│
│ └───────────────┘ │     └────────────────────────┘
│ Jeep Renegade     │
│ 2023 • Palmas     │     RESERVAS
│ [Automático][5]   │     ┌────────────────────────┐
│ Sobre este carro  │     │ Minhas reservas         │
│ R$219  [Reservar] │     │ Veículo car_001         │
└───────────────────┘     │ Período • Pendente     │
                          └────────────────────────┘
```

## Fluxo do usuário
Login → Explorar → Buscar → Detalhes → Escolher retirada/devolução → Solicitar reserva → Aba Reservas.

## Design System
Paleta principal: floresta `#174A38`, lima `#CBF36B`, tinta `#16271F`, fundo `#F7F8F3`, cinza `#718077`, linhas `#E4EAE2`. Tokens: espaçamento 4/8/16/24/32; raios 12/18/26. Tipografia Material 3 com hierarquia de texto. Componentes: `VeoButton`, `VeoTextField`, `VeoChip`, `VeoVehicleCard`, `VeoSectionTitle`, `VeoState`. O Sample App demonstra tokens, botões, entradas, cards, estados e variações.

## Arquitetura e padrões
- **MVVM**: View = UI; ViewModel = loading, erro e regras de apresentação.
- **Repository**: contrato `VehicleRepository`, com implementações `MockVehicleRepository` e `HttpVehicleRepository` substituíveis.
- **Factory**: composição de dependências de login e home.
- **Coordinator**: centralização da navegação login→home e home→detalhes.
- **Design System**: componentes isolados da lógica de negócio em pacote próprio.
- **Injeção de dependência**: repositório passado por construtor, evitando acoplamento direto do widget ao HTTP.

## Regras e estados
- Lista: loading, erro e vazio, com componente `VeoState`.
- Login inválido mostra mensagem; credenciais da demonstração no README.
- Datas: escolha em calendário; mock retorna `pending` e valor = diárias inclusivas × preço.
- API HTTP rejeita período inválido e reserva duplicada (409); mock local simplifica disponibilidade e não impede sobreposição (limitação conhecida).
- Falhas da API: payload padronizado e HTTP 4xx/5xx.

## Fora de escopo
Cadastro de proprietários, CNH e identidade real, seguros, rastreadores, chat, mapas, pagamentos e repasses. **Não se trata de produto pronto para locações reais.**

## Critérios de aceite
- Navegar entre login, busca, detalhes, reservas e perfil.
- Ver quatro carros de exemplo sem servidor HTTP.
- Buscar marca ou cidade e abrir detalhes.
- Escolher período e registrar solicitação de reserva local.
- Executar Sample App isoladamente.
- Iniciar API Node e consultar `/health`, `/vehicles`, `/bookings`.
