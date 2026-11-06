# VEO — Versão com aluguel e anúncios (06/11/2026)

## Alterações mantendo a base anterior
- Mantido tema verde-floresta + lima, Design System, MVVM, Factory, Repository e Coordinator existentes.
- Navegação principal: Explorar | Reservas | Anunciar | Perfil.
- Explorar: busca original + filtros de câmbio, categoria (heurística pelo modelo) e valor máximo da diária. Filtros locais combinados com busca no repositório.
- Detalhes: galeria por `photoUrls` com paginação; carros antigos têm uma única imagem, pois as fontes originais só forneciam uma imagem por carro. Não inventamos fotos de interior/porta-malas.
- Reservar: escolha de datas existente + resumo de diárias e total + confirmação explícita antes de POST.
- Reservas: listagem e cancelamento com confirmação; canceladas não bloqueiam mais datas.
- Anunciar: formulário de carro, até 3 links HTTPS de fotografias, preço, cidade, ano, modelo, câmbio, combustível, lugares e descrição; gerenciamento para pausar/reativar.
- Anúncios ativos passam a integrar o catálogo; anúncios pausados somem da exploração, mas continuam em 'Meus anúncios'.
- Modo local: SharedPreferences por `usr_001` para anúncios e reservas.
- Modo HTTP: `server/data/listings.json` e `server/data/bookings.json`; login demo e token `demo-token`.

## API nova
- `GET /my-listings` — listar anúncios do proprietário demo.
- `POST /my-listings` — cadastrar anúncio.
- `PATCH /my-listings/:id` — `{ "status": "active" | "paused" }`.
- `DELETE /bookings/:id` — cancelar solicitação.

### POST /my-listings — exemplo
```json
{
  "brand":"Honda","model":"Fit","year":"2020","city":"Palmas, TO",
  "transmission":"Automático","fuel":"Flex","seats":5,
  "dailyPrice":185,"description":"Carro conservado, pronto para viagens.",
  "imageUrl":"https://example.com/fit.jpg",
  "photoUrls":["https://example.com/fit.jpg"]
}
```
Resposta: `201` com ID, ownerId e status `active`. Respostas de validação: `422`, autenticação: `401`.

## Limites do protótipo acadêmico
- Uma conta de demonstração (`clara@veo.app`), não contas reais separadas com permissões robustas.
- Fotos via links HTTPS, sem upload de arquivos/câmera.
- Sem aprovação de anúncios, seguro, pagamentos, verificação de CNH, contratos ou controle de terceiros.
- Categorização por palavras-chave no modelo; não é categorização automotiva oficial.
- O backend é mock local e não deve ficar público na internet.

## Execução
```bash
cd server
npm test
npm start
```
Segundo terminal na pasta principal:
```bash
flutter pub get
flutter run -d chrome --dart-define=USE_HTTP=true --dart-define=API_URL=http://localhost:8080
```
Para executar localmente sem API: `flutter run -d chrome`.

## Testes
Os testes Node.js incluem publicação, persistência, pausa, reativação, validação e cancelamento de reservas. A compilação Flutter precisa ser verificada em uma máquina com Flutter SDK instalado.
