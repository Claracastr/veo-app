# VEO — alugue sua liberdade

Projeto acadêmico de **aluguel de carros P2P**, desenvolvido em Flutter/Dart e inspirado na organização da entrega Triply, mas com produto, marca, telas e componentes próprios.

## Estrutura
```
lib/                         App Flutter
  models/                    Vehicle e Booking
  services/                  Interface Repository + implementações Mock e HTTP
  scenes/login/              View, ViewModel, Factory, Coordinator
  scenes/home/               View, ViewModel, Factory, Coordinator
  scenes/vehicle_details/    Detalhe e escolha de datas
  scenes/bookings/           Listagem das solicitações
packages/design_system/      Componentes e tokens reutilizáveis
  example/                  Sample App / catálogo de componentes
server/                      API mock Node.js sem dependências externas
docs/                        Contrato da API, wireframes e escopo
```

## Rodar aplicativo
Requisitos: Flutter SDK (Dart incluso), Android Studio/VS Code ou Chrome.
```bash
cd VEO_Projeto_Entrega
flutter pub get
flutter run
```
Credenciais de demonstração: **clara@veo.app** / **123456**.

Por padrão o app usa `MockVehicleRepository` (sem iniciar servidor). Para usar a API HTTP:
```bash
# Terminal 1
cd server
npm start
# Terminal 2 na raiz
flutter run --dart-define=USE_HTTP=true --dart-define=API_URL=http://10.0.2.2:8080
```
Em Chrome ou iOS simulator substitua API_URL por `http://localhost:8080` quando apropriado. Android usa `10.0.2.2` para acessar o host. A autenticação visual é demonstrativa; token HTTP fixo `demo-token`.

## Rodar Sample App (Design System)
```bash
cd packages/design_system/example
flutter pub get
flutter run
```
O menu lateral demonstra cores, tipografia, espaçamento, botões, campos, chips, cards e estados.

## Testar API
Requer Node 18+:
```bash
cd server
npm test
npm start
```
Endpoint inicial: http://localhost:8080/health. Confira `docs/api-contract.md` para requests/responses e status.

## Observações
- Fotos remotas demonstrativas (Unsplash) podem não corresponder à marca/modelo; em modo offline aparece um ícone ilustrativo.
- O mock Node armazena reservas na memória e reinicia a cada execução.
- Foram entregues protótipos textuais e telas executáveis em Flutter; não há arquivo Figma.
- Um projeto Flutter novo pode precisar gerar plataformas nativas (`flutter create .`) antes do primeiro `flutter run`, pois a pasta entrega concentra código fonte, pacote e servidor.
- Não há pagamentos, seguro, checagem de CNH ou transferências reais.


## Atualização da aula — 06/11/2026

Veja `docs/status-objetivos-06-11-2026.md` para o checklist de objetivos e as melhorias feitas nesta versão.

- Design System e Sample App ampliados com badges de status e componente de preço.
- Tela de reservas e de detalhes padronizadas com MVVM + Factory.
- Mock local agora rejeita reservas em períodos sobrepostos.
- Testes adicionais para API e repositório local.

**Flutter com backend HTTP no Chrome:**

```bash
flutter run -d chrome --dart-define=USE_HTTP=true --dart-define=API_URL=http://localhost:8080
```

**Flutter com mock local:** `flutter run -d chrome` (não depende do servidor).

## Atualização: mais carros e reservas persistentes

- Catálogo ampliado de 4 para **22 carros** distribuídos em Palmas, Araguaína, Goiânia, Brasília, Belo Horizonte, São Paulo, Curitiba, Rio de Janeiro, Salvador, Recife, Fortaleza, Londrina e Campinas. Use a busca já existente para filtrar pelo nome ou cidade. As imagens são ilustrativas.
- **Modo local padrão:** ao solicitar uma reserva, o app salva no `shared_preferences`, identificado pelo usuário demo `usr_001`. Ao fechar/abrir a página no mesmo navegador/perfil, as reservas continuam na aba **Reservas**. Para funcionar, execute `flutter pub get` depois da atualização.
- **Modo HTTP:** a API grava reservas em `server/data/bookings.json` e as vincula à conta demo. O arquivo sobrevive à reinicialização do `npm start`. A aba Reservas consulta o servidor. A pasta `server/data` é ignorada pelo Git.
- Ambas as opções são **demonstrações acadêmicas**: só há um usuário autorizado de exemplo (`clara@veo.app`), sem autenticação multiusuário de produção. Os dois modos mantêm reservas em **armazenamentos separados**; não há sincronização automática entre Flutter local e servidor HTTP.
- Para executar com a API no Chrome, inicie o servidor (`cd server && npm start`) e, na raiz do Flutter, use: `flutter run -d chrome --dart-define=USE_HTTP=true --dart-define=API_URL=http://localhost:8080`.
- Caso você tenha reservas antigas feitas *antes* desta atualização, elas eram guardadas apenas em memória e não podem ser recuperadas.
- Para não perder reservas, use o mesmo navegador e não limpe os dados do site no modo local. No modo servidor, não apague `server/data/bookings.json`.


## Atualização — fotografias e calendário de reserva
- Imagens dos 22 anúncios substituídas por fotografias identificadas pelo modelo no Wikimedia Commons (catálogo Flutter local e API HTTP). São imagens ilustrativas, não fotografias do carro anunciado. Consulte `docs/fotos-veiculos.md` para atribuição e limitações.
- Reserva abre um diálogo compacto com campos Retirada e Devolução e botão verde **Confirmar período** do Design System.
- A reserva continua vinculada à conta e salva como na versão anterior. Reinicie o servidor após descompactar esta versão para ler as novas fotos.

## Novidade — Dois caminhos no VEO

A navegação agora tem **Explorar (alugar um carro)**, **Reservas**, **Anunciar (oferecer seu carro)** e **Perfil**. A versão contém filtros, galeria com as fotos disponíveis, resumo de reserva, cancelamento e cadastro/pausa de anúncios. Todos os detalhes e os contratos adicionais estão em `docs/novidades-dois-modos.md`.

**Atenção:** esta é uma demonstração com um único usuário, sem pagamentos ou verificação documental. O ambiente de API mock deve ser usado apenas localmente.
