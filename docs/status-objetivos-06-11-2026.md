# VEO — Verificação dos objetivos da aula (06/11/2026)

## Objetivos e evidências

| Objetivo | Resultado | Arquivos de evidência |
|---|---|---|
| Design System pronto | Concluído para o escopo acadêmico atual | `packages/design_system/lib`, `packages/design_system/example` |
| Sample App | Concluído com tokens, botões, entradas, cards, estados, preço e status | `packages/design_system/example/lib/main.dart` |
| Mock backend | Concluído para o fluxo demonstrativo de login, catálogo e reserva | `server/server.js`, `server/server.test.js` |
| Iniciar telas no padrão de projeto | Iniciado e padronizado nas telas centrais | `lib/scenes/login`, `home`, `bookings`, `vehicle_details` |

## Alterações feitas sobre a versão recebida

1. Mantidas as telas e o tema da versão enviada, sem redesenhar o trabalho existente.
2. Adicionados `BookingsViewModel` e `BookingsFactory`; tela de reservas passa a usar estado/loading/erro controlado por ViewModel.
3. Adicionados `VehicleDetailsViewModel` e `VehicleDetailsFactory`; criação de reserva sai da View.
4. Adicionados componentes reutilizáveis `VeoStatusBadge` e `VeoPriceTag` ao Design System e exemplos no Sample App.
5. Mock local em Dart agora valida data anterior à atual e bloqueia reservas que se sobrepõem, como o mock HTTP.
6. Adicionados testes Flutter para repositório mock e testes de endpoints HTTP.

## Padrões demonstráveis

- **MVVM:** `*View` apenas interface; `*ViewModel` contém estado e chamadas assíncronas.
- **Factory:** cria ViewModels com suas dependências (`LoginFactory`, `HomeFactory`, `BookingsFactory`, `VehicleDetailsFactory`).
- **Repository:** `VehicleRepository` abstrai dados; implementações mock local e HTTP.
- **Coordinator:** `LoginCoordinator` e `HomeCoordinator` direcionam as transições existentes.
- **Injeção de dependência:** Views recebem `VehicleRepository` via construtor.

## Como executar

Terminal 1, dentro da pasta `server`: `npm test` e `npm start`.

Terminal 2, na pasta raiz do projeto: `flutter pub get` e `flutter run -d chrome`.

Para conectar o Flutter ao servidor HTTP (em vez do mock local):

`flutter run -d chrome --dart-define=USE_HTTP=true --dart-define=API_URL=http://localhost:8080`

> Atenção: o servidor usa token acadêmico fixo. O login do app ainda é demonstrativo.

Para executar o Sample App, entre em `packages/design_system/example` e rode `flutter pub get` seguido de `flutter run -d chrome`.

## Limites

O design system está pronto **para o escopo desta entrega**, não para produção. A navegação, o layout e a disponibilidade precisam de validação no SDK Flutter local. Não há checkout, verificação de CNH, seguro, banco de dados ou autenticação real.
